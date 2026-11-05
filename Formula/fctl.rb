class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.28.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "e0eccdd588749c10d7cf3fb25d2d60326e9e2bb91b99712b230ab4d6570fe580"
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
      url "https://fctl.sh/releases/v0.28.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.28.0"
      sha256 "bfad5e3325769e7e14151eb12d4fdb24eae9b4a09bb3a460f401028806fe4b99"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.28.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "62cdd653c3e6241e6c34fbeeb3d03eb21fa4af9c843629ab79bd39de68de90af"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.28.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.28.0"
      sha256 "b59424dc48685e43d5248387e0de989cee6d795930d072fc7d318661fd678ee8"
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
