#!/usr/bin/env bash
# Opens a pull request for each formula in TAP that livecheck finds a newer
# version of, updating the URL, version and checksum for every OS and
# architecture. `brew bump` can't: it rewrites only a formula's top-level url
# and sha256, so the archives in on_macos, on_linux, on_arm and on_intel blocks
# would keep the old version.
#
# Usage: .github/scripts/bump-formulae.sh TAP [--dry-run | --merge]
#
# With --dry-run it updates the formulae in the tap but doesn't commit, push or
# open pull requests. With --merge it merges each pull request it opens once
# the checks that the tap's main branch requires pass on it, which takes a
# token that may merge without a code owner's approval.

set -euo pipefail

tap="${1:?Usage: $0 TAP [--dry-run | --merge]}"
mode="${2:-}"

# Prints an error, as an annotation on GitHub Actions, and exits.
fail() {
  if [[ -n "${GITHUB_ACTIONS:-}" ]]; then
    echo "::error::$*"
  else
    echo "Error: $*"
  fi >&2
  exit 1
}

case "${mode}" in
  "" | --dry-run | --merge) ;;
  *) fail "Unknown option ${mode}; usage: $0 TAP [--dry-run | --merge]" ;;
esac

# Replaces each FROM in FILE with TO, as plain strings, failing if there's none.
replace() {
  local file="$1" from="$2" to="$3"
  grep -qF -- "${from}" "${file}" || fail "${file} has no ${from}."
  FROM="${from}" TO="${to}" perl -pi -e 's/\Q$ENV{FROM}\E/$ENV{TO}/g' "${file}"
}

# `brew info --json=v2 --variations` shows a formula as it is on this OS and
# architecture, and under variations what differs on each of the others. These
# read it from stdin.

# Prints the versions the formula has across every OS and architecture.
versions_of() {
  jq -r '[.formulae[0] | ., .variations[] | .versions.stable // empty] | unique | join(", ")'
}

# Prints each URL the formula downloads on some OS and architecture, that URL
# with CURRENT changed to LATEST, and its checksum.
sources_of() {
  jq -r --arg current "$1" --arg latest "$2" '
    [.formulae[0] | ., .variations[] | .urls.stable // empty] | unique_by(.url)[]
    | [.url, (.url | split($current) | join($latest)), .checksum // ""] | @tsv'
}

# Prints the state of each of the checks REQUIRED (JSON, from the rules API)
# in the check runs on stdin, as "STATE<tab>CHECK": pass, fail or pending. The
# newest run of a check counts, as on GitHub, and neutral and skipped ones pass.
states_of() {
  jq -r --argjson required "$1" '.check_runs as $runs | $required[] as $check
    | [$runs[] | select(.name == $check.context and .app.id == ($check.integration_id // .app.id))]
    | max_by(.id)
    | [if . == null or .status != "completed" then "pending"
       elif .conclusion == "success" or .conclusion == "neutral" or .conclusion == "skipped" then "pass"
       else "fail" end,
       $check.context]
    | @tsv'
}

# Merges the pull request URL once the checks that the base branch requires
# pass on COMMIT, which must still be its head. Fails, leaving it open for a
# person, if one of them fails or they take more than 45 minutes.
merge() {
  local url="$1" commit="$2" required states failed
  required="$(gh api "repos/{owner}/{repo}/rules/branches/${base}" \
    --jq '[.[] | select(.type == "required_status_checks") | .parameters.required_status_checks[]] | unique')"
  if [[ "${required}" == "[]" ]]; then
    fail "${base} requires no checks, so ${url} would merge untested; it stays open for a person to merge."
  fi

  echo "Waiting for the checks ${base} requires to pass on ${url}"
  for _ in {1..90}; do
    sleep 30
    # GitHub's API fails now and then; the next try may not.
    states="$(gh api "repos/{owner}/{repo}/commits/${commit}/check-runs?per_page=100" | states_of "${required}")" ||
      continue
    failed="$(awk -F '\t' '$1 == "fail" { printf "%s%s", sep, $2; sep = "; " }' <<<"${states}")"
    if [[ -n "${failed}" ]]; then
      fail "${failed} failed on ${url}, so it stays open for a person to fix and merge."
    fi
    if ! grep -q '^pending' <<<"${states}"; then
      # --admin merges without a code owner's approval, which only the bump
      # app may (.github/rulesets/main-reviews.json); GitHub still holds the
      # merge to the checks. --match-head-commit keeps out anything pushed
      # to the branch since.
      gh pr merge "${url}" --squash --admin --match-head-commit "${commit}" ||
        fail "Couldn't merge ${url}, so it stays open for a person to merge."
      return
    fi
  done
  fail "The checks on ${url} didn't finish in 45 minutes, so it stays open for a person to merge."
}

bump() {
  local name="$1" current="$2" latest="$3"
  local formula="${tap}/${name}" branch="bump-${name}-${latest}"
  local prs info path versions sources url new_url checksum new_checksum body commit pr

  echo "==> ${formula} ${current} -> ${latest}"

  if [[ "${mode}" != --dry-run ]]; then
    prs="$(gh pr list --head "${branch}" --state all --json url --jq '.[].url')"
    if [[ -n "${prs}" ]]; then
      echo "Already proposed in ${prs}"
      return
    fi
  fi

  info="$(brew info --json=v2 --variations "${formula}")"
  path="$(jq -r '.formulae[0].ruby_source_path' <<<"${info}")"
  versions="$(versions_of <<<"${info}")"
  if [[ "${versions}" != "${current}" ]]; then
    fail "${formula} is ${versions} on different platforms; it needs to be ${current} on all of them."
  fi

  sources="$(sources_of "${current}" "${latest}" <<<"${info}")"
  while IFS=$'\t' read -r url new_url checksum; do
    if [[ "${new_url}" == "${url}" ]]; then
      fail "${formula} downloads ${url}, which doesn't have ${current} in it."
    fi
    if [[ -z "${checksum}" ]]; then
      fail "${formula} has no checksum for ${url}."
    fi

    echo "Downloading ${new_url}"
    new_checksum="$(curl --fail --silent --show-error --location --retry 3 "${new_url}" | shasum --algorithm 256)"
    replace "${path}" "\"${url}\"" "\"${new_url}\""
    replace "${path}" "\"${checksum}\"" "\"${new_checksum%% *}\""
  done <<<"${sources}"

  # Formulae set the version where Homebrew can't scan it from the URL.
  if grep -qF "version \"${current}\"" "${path}"; then
    replace "${path}" "version \"${current}\"" "version \"${latest}\""
  fi

  versions="$(brew info --json=v2 --variations "${formula}" | versions_of)"
  if [[ "${versions}" != "${latest}" ]]; then
    fail "${formula} is ${versions} on different platforms after the update, not ${latest} on all of them."
  fi
  brew fetch --formula --all-platforms --build-from-source "${formula}"
  brew audit --formula --os=all --arch=all "${formula}"

  if [[ "${mode}" == --dry-run ]]; then
    git --no-pager diff -- "${path}"
    return
  fi

  body="Livecheck found ${name} ${latest}. This updates the URL, version and checksum for every OS and architecture, and \`brew fetch --all-platforms\` and \`brew audit --os=all --arch=all\` passed."
  if [[ -n "${GITHUB_RUN_ID:-}" ]]; then
    body+="

Opened by ${GITHUB_SERVER_URL:?}/${GITHUB_REPOSITORY:?}/actions/runs/${GITHUB_RUN_ID}"
    if [[ "${mode}" == --merge ]]; then
      body+=", which merges it once the checks that ${base} requires pass. If one fails, it stays open for a person to fix and merge."
    else
      body+="."
    fi
  fi

  git checkout --quiet -b "${branch}"
  git commit --quiet --message="${name} ${latest}" -- "${path}"
  commit="$(git rev-parse HEAD)"
  # No pull request has the branch (see above), but a run that failed to open
  # one may have pushed it.
  git push --quiet --force origin "${branch}"
  pr="$(gh pr create --base "${base}" --head "${branch}" --title "${name} ${latest}" --body "${body}")" ||
    fail "Couldn't open the pull request for ${branch}; the next run tries again."
  echo "Opened ${pr}"
  git checkout --quiet "${base}"

  if [[ "${mode}" == --merge ]]; then
    merge "${pr}" "${commit}"
  fi
}

repository="$(brew --repository "${tap}")"
cd "${repository}"
base="$(git branch --show-current)"

livecheck="$(brew livecheck --tap="${tap}" --formulae --json)"
jq -r '.[] | select(.version.outdated == false) | "\(.formula) \(.version.current) is up to date."' <<<"${livecheck}"

outdated="$(jq -r '.[] | select(.version.outdated) | [.formula, .version.current, .version.latest] | @tsv' <<<"${livecheck}")"
while IFS=$'\t' read -r -u 3 name current latest; do
  if [[ -n "${name}" ]]; then
    bump "${name}" "${current}" "${latest}"
  fi
done 3<<<"${outdated}"

# livecheck succeeds even when it couldn't check some formulae.
errors="$(jq -r '.[] | select(.status == "error") | "\(.formula): \(.messages | join(" "))"' <<<"${livecheck}")"
if [[ -n "${errors}" ]]; then
  fail "livecheck couldn't check ${errors}"
fi
