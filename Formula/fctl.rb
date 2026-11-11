class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.33.5/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "99b6302973f3475bc9e4d0bb587a2f57b17e0432cecddd53e67096ebd992377b"
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
      url "https://fctl.sh/releases/v0.33.5/fctl-x86_64-apple-darwin.tar.gz"
      version "0.33.5"
      sha256 "90fb67605e14b2a5de0372f899c7b9f9f33ce69f1d7f8881d1b22b68aa603758"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.33.5/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "96087045cb28265d119f03c745bcd4a6939474c09845707f5319cf27137fd6f7"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.33.5/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.33.5"
      sha256 "8d5ae554f127c3b72a387d3a821c496134e0267daa027fe4e41b292a1a032780"
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
