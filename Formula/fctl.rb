class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.33.6/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "c7993b963907697aade989a53ab09acb96a6439124ab264e103bc2cf059766b8"
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
      url "https://fctl.sh/releases/v0.33.6/fctl-x86_64-apple-darwin.tar.gz"
      version "0.33.6"
      sha256 "7cb2ec9e44bd4bd65fcc9e5913b3e1d9e65baa8d5d5c89980986c287ece32adc"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.33.6/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0078c652f4fa1a635031fd9f5c63ca63b4e48d8fd98d362cbddb34a8b9a3b238"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.33.6/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.33.6"
      sha256 "4d7c5cd95e6f136a7363d221e04e53b777c8274ce3597d004b8c385d862b2fa4"
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
