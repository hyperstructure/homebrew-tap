class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.32.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "690bb10a9b6409c45610a2bc27bcb45c8e3ab10df651aaf49dec57a8d475261a"
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
      url "https://fctl.sh/releases/v0.32.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.32.0"
      sha256 "76b413c09f54826c2c1dfd24ae290d015203dc84bca9e2421b0bce1d5737158a"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.32.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1e0c3b847d615115ec32bd6fb45357cc46561416db15a1b2c1c63f619be95e34"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.32.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.32.0"
      sha256 "4a54aa1282639c0f434c21dd2728242a5fff39794f29f02c47ad786cc0103e47"
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
