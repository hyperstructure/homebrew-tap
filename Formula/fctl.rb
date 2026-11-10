class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.33.2/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "8e152f020ba0d6cc2be7ea924ee2ba9f6ebda4dfa31abbfbd4d531a4292488f5"
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
      url "https://fctl.sh/releases/v0.33.2/fctl-x86_64-apple-darwin.tar.gz"
      version "0.33.2"
      sha256 "7fa9047abd873aef16a76e9d9b101dbde8bdecc98af0594881eeb631a5b21287"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.33.2/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a21edfc53e22e4ecb7b62d3b615fdf512534e0f188dab2bc67839ea027d14290"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.33.2/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.33.2"
      sha256 "c568a7763f7c6dd1ef08a1017b01c0c7d9706c4fd4d78001e791286687e432d9"
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
