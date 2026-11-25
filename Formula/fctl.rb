class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.38.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "c1af8b2ecfb15d5f2e357e9970029f4f93605e753189cd233c4e613ccd4596b7"
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
      url "https://fctl.sh/releases/v0.38.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.38.1"
      sha256 "8f684d9ef3261f0b7b90d1481ee88c7efdece57c1a594e161d283b7ee29a6540"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.38.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e6eedd777bd5630bb8235d4dd4f182eaac642e14c6fe132398e9e9457772c439"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.38.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.38.1"
      sha256 "9b119347fe04a9aeeb6d2c084b83b5fcdfe86ced49402a464d2fc7e5de8d9366"
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
