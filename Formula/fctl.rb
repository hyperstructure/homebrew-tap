class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.33.3/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "dc6d40144bbdaeace9f114bf927a451029cd451c7de5f9945eaa7b0a4a01cded"
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
      url "https://fctl.sh/releases/v0.33.3/fctl-x86_64-apple-darwin.tar.gz"
      version "0.33.3"
      sha256 "67c84d3c25cac1c86371884a982b9f38111312d42e12ddf5d18552a89e09304f"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.33.3/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "db4a23100222f4c92773d3583ac5dfd6947f031ca63087e5dd5d044227265c94"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.33.3/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.33.3"
      sha256 "dad2ad2ae6b2bb149e2e0547f4177e12308e8e410454d604c461516d1fcc29b1"
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
