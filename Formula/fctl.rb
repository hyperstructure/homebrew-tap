class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.27.2/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "b6f679933339e9a13c17651cec2c15274ff21566c29eeb482562623a89d75ad8"
  license "MIT"
  # Intel Macs got 0.7.0 as version "64-apple-darwin", which sorts above every
  # release, so brew upgrade only replaces it under a new version scheme.
  version_scheme 1

  livecheck do
    url "https://fctl.sh/releases/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  # Homebrew scans the version from the URL, but in the x86_64 file names it
  # finds "64-apple-darwin" or "64-unknown-linux-musl" first, so those set it.
  on_macos do
    on_intel do
      url "https://fctl.sh/releases/v0.27.2/fctl-x86_64-apple-darwin.tar.gz"
      version "0.27.2"
      sha256 "146da2ab6e4fe58214b1c05e1b6d72cc7fc0f157bfc7c00a654c5b59f881b574"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.27.2/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "97eba415f9e08adb4468ee62806b719b9891a08ef5eb968304719f4a82834878"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.27.2/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.27.2"
      sha256 "bba974c949fc8369058772698638399dfd3605028b5c97dec5d5673984e27fd3"
    end
  end

  def install
    bin.install "fctl"
    # The archive also carries the Linux agent that sandboxes run, which fctl
    # looks for next to itself. On macOS it isn't an executable Homebrew
    # accepts in bin; fctl downloads it, checked against its SHA-256, on first use.
    bin.install Dir["fctl-agent-*-linux"] if OS.linux?

    generate_completions_from_executable(bin/"fctl", "completions")
  end

  def caveats
    <<~EOS
      Update with `brew upgrade fctl`, not `fctl self update`.

      Next:
        fctl login app.fctl.sh
        fctl host install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fctl --version")
  end
end
