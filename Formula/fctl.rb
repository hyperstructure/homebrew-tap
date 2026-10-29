class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.27.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "4d4e5b30257631828b0181dc4ee10d5eee95957ec57a21b8e8186b4fad2e4bf4"
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
      url "https://fctl.sh/releases/v0.27.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.27.0"
      sha256 "0a99c163de3c505a376e52829fb800ebb94ecf104907b1a7951b0ecd1d3b94f2"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.27.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "444094cb883ee8a32005910485bbeb37b357adb2ce04be0c3ab9c02646c0e810"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.27.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.27.0"
      sha256 "c7910fdf8240c8668fe8652bfa8246e6ce0f26ab8133e240d067bff1ea2a9e2d"
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
