class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.20.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "16063905a54facf188c3d405505430fda44c49814175c961a5d0c7ff21ca8be0"
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
      url "https://fctl.sh/releases/v0.20.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.20.1"
      sha256 "0cd77b8f173ddcf6435fb544cc79df2773a9928b4c2323a1ef0d819e61f08efe"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.20.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9b44a4ff98f8f22b130197686e463c8aedce2f15669aeed6e72af6b03ac0cc22"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.20.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.20.1"
      sha256 "d356a8d13d79ca377b628e3ec808438a872d3d5b6c419b0ca3fbd9df6c6a14fd"
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
