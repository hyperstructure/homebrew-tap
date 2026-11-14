class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.34.3/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "4150d3b208b11b0e22a05a092b6be97655101f15dce0331f1852c2d211472477"
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
      url "https://fctl.sh/releases/v0.34.3/fctl-x86_64-apple-darwin.tar.gz"
      version "0.34.3"
      sha256 "555841dc312a031036054c85e0626897b9b97ceffbfc9858dde213d36908b265"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.34.3/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "050cb4993a39fea3bb5511e3299cccd33949b5f63da79b7b4b3f8dc0e1e1a76b"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.34.3/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.34.3"
      sha256 "617b2417863fdc5970cc2be686ec719c4e990b11f54689b541c021fe7f0fb50f"
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
