class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.23.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "013153c05961f8c47d25944dce660ea6213cd915b23845f5c1107d34fae32c51"
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
      url "https://fctl.sh/releases/v0.23.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.23.0"
      sha256 "6a5cf50f81859dfd521ac477d43c7bd73174af371fa28ced3ec6f769ba32be86"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.23.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "036b0fdccb224808bd06c53842b19c00561c86cfcb59a5d1d6df21c5318b20b7"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.23.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.23.0"
      sha256 "a75babeb75b6318fac66fe219d67a37844017106db53fa94cb9a8fbcbd517ff4"
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
