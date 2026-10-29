# Security policy

Please report vulnerabilities privately through GitHub's **Security → Report a
vulnerability** on this repository, not in a public issue. We acknowledge
reports within three working days.

## How this tap is kept safe

- `main` takes changes only through pull requests whose checks pass
  (`.github/rulesets/main.json`), and that a code owner, who did not push the
  last commit, approves (`.github/rulesets/main-reviews.json`).
- Formulae download only from `https://fctl.sh/releases` and pin each archive
  by SHA-256. When livecheck finds a new release, the `brew bump` workflow
  (`.github/scripts/bump-formulae.sh`) rewrites the version, URLs and checksums
  in a pull request, and merges it once its checks pass. fctl's Release
  workflow starts it as soon as a release is out, with a token that can use
  this repository's Actions and nothing else; it also runs every day.
- The bump workflow opens and merges those pull requests as the bump app, a
  GitHub App that may merge a pull request without a code owner's approval,
  but not push to `main` or skip its checks. It merges only the commit it
  pushed. The app's key is a secret of the `production` environment, which
  only `main` may use, so workflows on other branches can't act as the app.
- Workflows start with `permissions: {}`, grant each job only what it needs,
  and pin every action to a commit SHA (Dependabot keeps them current;
  zizmor lints them).
