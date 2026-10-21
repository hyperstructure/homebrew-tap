class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.14.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "90834693688d1515b7e75cc1d9082f0a84e9feb0c57ecb798d1759d5adbba1c9"
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
      url "https://fctl.sh/releases/v0.14.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.14.1"
      sha256 "a1fc520db3bef2896413a87437d9aba02f8f1fa61bc41a5fcbf73989737ec614"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.14.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ecdf8d9b3b6aeb01c3fd16d1c2676ee9dba9dcd2e984381a804a2bd0addd9463"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.14.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.14.1"
      sha256 "dceb5da58478d94308c73bdfebcb047948c06de3c1cb35437cbb3d5f5e96814c"
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
