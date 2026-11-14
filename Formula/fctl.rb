class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.34.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "76a2568f3430b37cdf48a904d508ae2e42a660aa6d7b21e4db299c1ff73479fe"
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
      url "https://fctl.sh/releases/v0.34.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.34.1"
      sha256 "f5cb30738b585b03528547840f49feb625f458ef775e91b0511107664c980491"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.34.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9a9e89f55c7c3862d0132ccbcae47f6888d2b34dc18937b9ee07d7d38bb0b62d"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.34.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.34.1"
      sha256 "bf13b2a6a92373831e1cc1c310173604b463998415f8d9e3aa79f9fccb376a6e"
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
