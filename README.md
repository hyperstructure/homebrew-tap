# Hyperstructure Tap

## How do I install these formulae?

`brew install hyperstructure/tap/<formula>`

Or `brew tap hyperstructure/tap` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "hyperstructure/tap"
brew "<formula>"
```

## Formulae

| Formula | |
| --- | --- |
| `fctl` | [fctl](https://fctl.sh), the CLI for running Claude Code agents in sandboxes. Installs the release archive from fctl.sh and pins its SHA-256. |

```sh
brew install hyperstructure/tap/fctl
```

Update with `brew upgrade fctl`. The default install, `curl -fsSL https://fctl.sh/install | sh`, works too; use one of the two, not both.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
