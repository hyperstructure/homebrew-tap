class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.31.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "6303dacb87328227b91d1ffff5abb7681dde5d61c28b49a35c09870b5c532511"
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
      url "https://fctl.sh/releases/v0.31.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.31.0"
      sha256 "36c6f2af7133e234b2ea47e084305b75f76e4bf9d68485d5fbfe47efd1f9a010"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.31.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fb275ebff9bffd17eaa94626b8f4688a258f283dda3fa5d31350f78a21876c79"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.31.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.31.0"
      sha256 "3bbfcc6057bb5e43300b1e789fcbd08d8cefcb03e21ebb11f47f1d3e005f3f3a"
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
