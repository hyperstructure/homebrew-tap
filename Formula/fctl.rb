class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.26.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "887dcc3504679c1945b236af815e6d5554f0b37a5905592d7d9748a8ddac69ec"
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
      url "https://fctl.sh/releases/v0.26.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.26.1"
      sha256 "171c2ca8a60fb5f4cb35e9c2ed29e536d98fda45b0e81ee3bdc15d4d4214b322"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.26.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "afcec351e58ef365f65422b0763c029176d8d98c7bb6e840744a62ebc5ab5b13"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.26.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.26.1"
      sha256 "330e4cd7407c6981649c7d4db05ee4cbabc0a3b1259d42b9ab03224904f6b2a3"
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
