class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.34.2/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "49200b773eab3337f4bd7bcc99caf8084148940ce093a64a4ba5c1250926de0b"
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
      url "https://fctl.sh/releases/v0.34.2/fctl-x86_64-apple-darwin.tar.gz"
      version "0.34.2"
      sha256 "a49c4f1f897be73b7c6b44a830c2af285b3df4f75fe80ddd564399d0708083ff"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.34.2/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "764f4c2970da606355d44519894220216585dc13becaa43bfb357120ded0195a"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.34.2/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.34.2"
      sha256 "e06f6ddd7def7a8bba3ff76a2fe5026c294904c1d90cdc07e35f461488cbaf7a"
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
