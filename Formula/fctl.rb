class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.18.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "e409dd502f58969815cb0695e49ef9754cd8278b0d78ff5116c0e08a9b3dc506"
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
      url "https://fctl.sh/releases/v0.18.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.18.0"
      sha256 "d53bed49be33b156212037f23abb11fa7595b043e496f3cb38977afa2df79d18"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.18.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f338f8d9a8343ecc2d085d37f1d5f349307db1a821819f73303610884ed079d0"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.18.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.18.0"
      sha256 "75a16623fc4ec54cc3214a3a4d5881dba50f67db05fe32266cca4d723b4b153f"
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
