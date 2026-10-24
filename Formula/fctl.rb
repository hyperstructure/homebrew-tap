class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.22.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "694bb5c5ef3ceb6ef35e379517053a277d363c1f2d78a6e64a8076f26328478f"
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
      url "https://fctl.sh/releases/v0.22.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.22.0"
      sha256 "630cebb93dcca52007f7416f5a4456f8863ba59b45019a756c44bc9a3e1ac5ce"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.22.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9d7d5979feeaad0adbbe4b180bdb9f09b80f5b8f58ab89227e1416414a2423e8"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.22.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.22.0"
      sha256 "15fb8ef70966af28afd5f99d4e6c70c468ef802b2336f19aeada31c39e437dbb"
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
