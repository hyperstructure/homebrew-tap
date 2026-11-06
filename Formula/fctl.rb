class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.30.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "363981d3af5f6437677993d2b690a3ea5262920d2d1f8fd922b518c2e969b13a"
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
      url "https://fctl.sh/releases/v0.30.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.30.0"
      sha256 "22de48af21daee3bde49d4499f582b99f1dcff6764fc52c920f550bc20e35e5c"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.30.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "52c3d4d02aa69aa70f75ea9fc770155e7c4034690a95a98e4625c576a9a8d759"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.30.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.30.0"
      sha256 "d42bd2a58525838df56dde4656be840f6c3089418250d6711537402f24890625"
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
