class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.29.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "b5e48832a626ef43776c87d0fe8d7953c8852cc34904fddc2c4a69c3e45b5192"
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
      url "https://fctl.sh/releases/v0.29.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.29.1"
      sha256 "74f486f6ef21782b3df233903dfbc27c5052ff6e4ab1b126fc77e8e1b81eee3f"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.29.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8cb945f47f05bbac8ea94c45e23cc6d6182d69977c20f2f178078db5e6c12f34"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.29.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.29.1"
      sha256 "e9ab1932131c3cd5ca38c0c6cb3edb996f13f6a278e18747face4973057ce266"
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
