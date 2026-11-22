class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.37.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "fd061b29fbd8ee57d65bc8bbc801fc806d9ddcabe54e26558db8b54b6c8836d6"
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
      url "https://fctl.sh/releases/v0.37.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.37.1"
      sha256 "b2b29bae698953bd0bb42cd47b0e490ab74d4a25d0f7967f79b13d24bb5bf129"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.37.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "524cdde8e14272b02d818e8bebdc36ba6e367db3f5055ded81ea95280184671d"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.37.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.37.1"
      sha256 "4d7355cf71372340e6b612329d025c1a907c706378ee0e27f9d53666e770192c"
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
