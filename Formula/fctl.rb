class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.33.4/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "631f949e8c95e6922508b686d20a6dadc9924a47d04bd453255a8ebd733a259f"
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
      url "https://fctl.sh/releases/v0.33.4/fctl-x86_64-apple-darwin.tar.gz"
      version "0.33.4"
      sha256 "3678d5120e717b7b3f0808e6976da640b6f68e39b3df877f3366d4539e560578"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.33.4/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e6986423ba5c9bcc7a8a8644790fa9bc84a6fabbaa1c5dac3f1a9cecf7387221"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.33.4/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.33.4"
      sha256 "aa229fd9617e3c4dda8d5466c48572126945fa1053003380e8179cfe5c8e1d1d"
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
