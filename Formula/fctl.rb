class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.36.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "f81453977d95ec810037b47e45dd153941637ce66f842575b9a652e2a2581d9c"
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
      url "https://fctl.sh/releases/v0.36.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.36.1"
      sha256 "72d02a27d4e941ce99ce7e3449bc8b796da35e2c7bb841bde09e0fc2c6892e8b"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.36.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "07410766e8e2986201fafff0cc2ee0959c866bbcb4175b237b17c57c646ab4b5"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.36.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.36.1"
      sha256 "4f1f2a1439e7256ddd8de96bc1293e416a2bd3dcef73b9bd6cc0260bbbd0cce2"
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
