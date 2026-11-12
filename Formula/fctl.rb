class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.34.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "6d182129033d44d8d8af3ef75c9deb030892522e2018c9241ef3f2bcae77baa5"
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
      url "https://fctl.sh/releases/v0.34.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.34.0"
      sha256 "7b91cb59b2c70a477508513e845714f117b6664682897767ef7e85d810d08240"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.34.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7ba3afa0cb5cb62d722285b4821342d0d402dc076d04b781bcfa740538a5f4c9"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.34.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.34.0"
      sha256 "d50571ab290569ce36ae1f34b0ca6c3ea6845e1e9adf51ad403d46abab125268"
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
