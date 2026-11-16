class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.35.3/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "af1320571e8dc69b871360cc5124dff05ce249bbfebdcf318b3243264cff2b76"
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
      url "https://fctl.sh/releases/v0.35.3/fctl-x86_64-apple-darwin.tar.gz"
      version "0.35.3"
      sha256 "402d61c4fb635c73f832698a3422bb786b756131ffbd1cdd2885bf79fcf3a000"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.35.3/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "06bf09559ca9da4860049091435bf6d23e0c3b8f36e68b29ae6d24f75a7d54e8"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.35.3/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.35.3"
      sha256 "a926dd62d655b045b19599cd9d8ae5cb88373d8f68d2d27090a91f3e3bf76e5b"
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
