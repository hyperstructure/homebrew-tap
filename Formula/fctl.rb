class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.16.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "f3cec0953f2675b175c393a8bd4d1f5e7b3a9ae020886baa36fdcf6c545a203f"
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
      url "https://fctl.sh/releases/v0.16.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.16.0"
      sha256 "0d26036529203794317f1ae2dba279861c9ffabdde641b2cc6b89a2dd9c4b526"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.16.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "29d8111f11a864f1de79470fe13462904fc3e709b39d56927f3f7b66733b968b"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.16.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.16.0"
      sha256 "c96420e5823a6a5ac0953af3e01bff5ac909a7daf96d8951ccee71e7f31a9928"
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
