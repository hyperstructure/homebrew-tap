class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.24.2/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "48165637ffd303572be99e9683aea695ae0ee2ff7a31b61a2f1bd71a63c621d6"
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
      url "https://fctl.sh/releases/v0.24.2/fctl-x86_64-apple-darwin.tar.gz"
      version "0.24.2"
      sha256 "592fe355c144027041987eba67d2bbe34a0013603f63aa14e128fef2ad108e62"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.24.2/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ebeb63a6c52ba914da49dcd0ba6c2f43fb929ef82999fbe46a3615e58eddba90"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.24.2/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.24.2"
      sha256 "bc18a2518c15290ed154c48097401575cfa09bc14aac96926b59bb5062539ccc"
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
