class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.27.3/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "45ae75108cefec8013cb14eb2aac9dc08ea39add5917107846226d1f8d3a2125"
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
      url "https://fctl.sh/releases/v0.27.3/fctl-x86_64-apple-darwin.tar.gz"
      version "0.27.3"
      sha256 "4a67bcfaa206db26867f983843f32f3810d8970b0ba0c1b9c4be01154ae01c1c"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.27.3/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bf009880ecc5e492f1a041bd34b5896ee0aa76f3d9037dc4a26a842e639e7e8e"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.27.3/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.27.3"
      sha256 "e03a2c9627087e753be15f13edd3f477161bd904cbec36f7ff0b9ebd24fc90fc"
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
