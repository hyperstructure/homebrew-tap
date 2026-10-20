# Security policy

Please report vulnerabilities privately through GitHub's **Security → Report a
vulnerability** on this repository, not in a public issue. We acknowledge
reports within three working days.

## How this tap is kept safe

- `main` takes changes only through pull requests that a code owner, who did
  not push the last commit, approves (`.github/rulesets/main.json`).
- Formulae download only from `https://fctl.sh/releases` and pin each archive
  by SHA-256. When livecheck finds a new release, the `brew bump` workflow
  (`.github/scripts/bump-formulae.sh`) rewrites the version, URLs and checksums
  in a pull request that a person reviews.
- Workflows start with `permissions: {}`, grant each job only what it needs,
  and pin every action to a commit SHA (Dependabot keeps them current;
  zizmor lints them).
