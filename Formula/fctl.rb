class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.23.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "7e84a26b7a65d61862dd67a7fc3555650ab829fa4bf787824ba5764ea90c13e4"
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
      url "https://fctl.sh/releases/v0.23.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.23.1"
      sha256 "5022436afcca7d304c73e1afe0c238b798c73705ba953bd7ff97ec33f7b34561"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.23.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c690bae143e839f51a777066c2a98160df8cca82a492b4629e5e828055eb7b68"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.23.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.23.1"
      sha256 "6e70c5b3546f0086d5a8226b941dac98bd185ae8b00d676b4981840223d5da01"
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
