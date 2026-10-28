class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.25.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "0903f3234573d10d82476eaed264fe86b671c04b115d36832657a60e472ab96d"
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
      url "https://fctl.sh/releases/v0.25.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.25.0"
      sha256 "7c5e3534ae13d959bd0e2f0f97aa86afcd2bbe46f2f85ed1201dd1202099eb5f"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.25.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2df6bd7cd21f80954db76ac68ea2e0a315f258d76ee02afb376f38d4813229b0"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.25.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.25.0"
      sha256 "094e8b1da5aa3505bf78a5537b07dc86919f0410ef6cab97492db397306a1e93"
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
