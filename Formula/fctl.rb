class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.19.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "2f6197e3be81c37c3d0fdf4acb7ec3dc1b577324d91501d8ea5747e26df0bf87"
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
      url "https://fctl.sh/releases/v0.19.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.19.0"
      sha256 "35b56c6452eeaab83e279b4981be374dc54335f64357d836e39d93a4d40c0d00"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.19.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ca6d4209b2efcd4a51046559d42ec6bd0275d8bd1c0ccb27671418fd7fdacc30"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.19.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.19.0"
      sha256 "fa0dd7d4f176706e99e32607b7beeec8b59f2549ff7eff8b727e8608ed0ef419"
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
