class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.17.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "f9f61e8cc4a889a36b7b3d847024ece7f4acb645121c63000ab2dda29917aca1"
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
      url "https://fctl.sh/releases/v0.17.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.17.1"
      sha256 "1f0bbff30eda9eef1c571462596a55137b1dd1d966593bf66b2227fd592c9b85"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.17.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "45e98fcac0f9bc073314e4b34ca7bd1e00dbed88dc493f1de0b9d2b6810f6dfa"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.17.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.17.1"
      sha256 "c7fec6bdbff660292d11a9a29c517ab169fdfc7b286e6fb9b9c0695d38124f27"
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
