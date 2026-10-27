class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.24.3/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "5999b5f461732d98bc19278794bf405ddff480ae742c4630703287c4c606ed7a"
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
      url "https://fctl.sh/releases/v0.24.3/fctl-x86_64-apple-darwin.tar.gz"
      version "0.24.3"
      sha256 "018e0a1ff7267cd141effdc27bac3ac36d42b0afdb827424c8909138cf4f1bfb"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.24.3/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "81624d5e7495b154f2a2d01454f5835e6c9065324b0818b427e110f6fe9dac3c"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.24.3/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.24.3"
      sha256 "af86d9d5fbbfa5255ea7075b1e4520471f4bc6402e9d83a2a513be3d54ae0654"
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
