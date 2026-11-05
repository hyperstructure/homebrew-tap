class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.29.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "5a8850eac2c6d43d54f47bb047d31b00d175a289ba3408cedd4acd903cbf373f"
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
      url "https://fctl.sh/releases/v0.29.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.29.0"
      sha256 "4a39675cdd0a4e41dc5d73d645e25b6d2989639808157d922c3adb35d0a965c3"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.29.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dbeee0bfd26395e873783e98a810adaa17087209c76664bc0b9a1d199f9ca7a1"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.29.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.29.0"
      sha256 "1e1bf710ea306ba0473c297098c0cc06554861f0e00447e325deac2ad81f2012"
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
