class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.20.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "6b531d1c68807527e3bf0f3ca2bfe864c5a20336b69060843b875b717e7d77ce"
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
      url "https://fctl.sh/releases/v0.20.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.20.0"
      sha256 "95ae3460aac53e2ffc1069d1c7a5a1c92b584702bc02225d8ea158319b0f3e8f"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.20.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d4eee834df27fd0330bafed7500cd171ecdd444d8d4f9b97cdf9f3dee2485630"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.20.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.20.0"
      sha256 "dfd6f921ae0028cdf44e777dba03c1b4586f6c0d29ea287e8f89bd5c5420c9a1"
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
