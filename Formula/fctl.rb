class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.35.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "a979537aa36e579ff6c645b40bf1f42cc25f4bfa5d1646e3f8db341ad24a395d"
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
      url "https://fctl.sh/releases/v0.35.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.35.1"
      sha256 "3b519981fc6aa176741c100f810f26a18c7a992afc5528822cf1bf6dc11633f9"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.35.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ddeca1edcf747bfb1477d75ba774f6ee37a7614859cf56624d6521f5f1907aea"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.35.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.35.1"
      sha256 "a7cfd1e6f9e527b2863868681e87fb403e96ff06d0f98b46d6d50a6623c02d8b"
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
