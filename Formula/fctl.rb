class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.38.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "6b331e4bf6bb8f5319e0aea963a76214ec48c4a6f68284696fbd2ee2344727ad"
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
      url "https://fctl.sh/releases/v0.38.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.38.0"
      sha256 "b681788ce2b158e3ebe80d6b10ee3afc978a857f4d0015633b214c0192618eaa"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.38.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "29b9e7c9e28c911433ae309df94402cc69c681ba046cc604736dd44dfd7f0fea"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.38.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.38.0"
      sha256 "1f53ded41c856857e20c488e398cbd40985edb3c4b5b73852a5f4d8adb60e600"
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
