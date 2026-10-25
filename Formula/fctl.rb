class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.24.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "db0af80aece558a0e7a645509a05b5480cb950ffc99be551cee02edd4d14866f"
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
      url "https://fctl.sh/releases/v0.24.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.24.0"
      sha256 "98b7cdd264317b3112a2c8ce76e7f58a93e36988cd6535a6235e9fe66b56662b"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.24.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "aa8dad0c785a804af82fa08813251dc6d29d66231b31d236a5c3d1a2d87eed65"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.24.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.24.0"
      sha256 "ad9e3b7caa11c6c8ffa7778ecccd0b13741a40420b84c3eeac1b6705b4381a1c"
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
