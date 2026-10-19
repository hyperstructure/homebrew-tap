# Hyperstructure Tap

## How do I install fctl from here?

```sh
brew install hyperstructure/tap/fctl
```

Or in a `brew bundle` `Brewfile`:

```ruby
tap "hyperstructure/tap"
brew "fctl"
```

You can also only add the tap, which makes formulae within it available in search results (`brew search` output):

```sh
brew tap hyperstructure/tap
```

While you may search across taps, it is necessary to always use the fully qualified name (including the `hyperstructure/tap/` prefix) when referring to formulae in external taps such as this one outside of search.

## Trusting formulae from this tap

Homebrew ignores formulae, casks and commands from third-party taps until they are trusted (see `brew trust --help`). Installing with the fully qualified name, as shown above, trusts that formula or cask automatically.

If you added the tap with `brew tap hyperstructure/tap`, Homebrew warns that the tap is not trusted until at least one of its formulae or casks is. Trust only the ones you need rather than the whole tap:

```sh
brew trust --formula hyperstructure/tap/fctl
```

## Formulae

| Formula | |
| --- | --- |
| `fctl` | [fctl](https://fctl.sh), the CLI for running Claude Code agents in sandboxes. Installs the release archive from fctl.sh and pins its SHA-256. |

Update with `brew upgrade fctl`. The default install, `curl -fsSL https://fctl.sh/install | sh`, works too; use one of the two, not both.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
