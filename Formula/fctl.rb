class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.32.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "a6230062894bb180bac0ba09df22de65bfd3347f2089a625a110c31f788c61ff"
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
      url "https://fctl.sh/releases/v0.32.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.32.1"
      sha256 "d4b6b909a8e8558434620ddb97b88d3981c4664bbd662dc098f7308d703c9c38"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.32.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ef7a923c52fa890b4197863d2ec93341e1e3bebc55efe271885a68c4aafd8bf8"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.32.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.32.1"
      sha256 "02a9c12704e2742caf0237bc1250dc9494988cfbd9b43b24117d10783b39b982"
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
