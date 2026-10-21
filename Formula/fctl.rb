class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.15.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "1eff0be0a6d84297a1a6d1966fcd16221349f97ccaecfbd8c4e67908de3d6354"
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
      url "https://fctl.sh/releases/v0.15.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.15.0"
      sha256 "e878297a24541ec27c95acbf3678c3b4b8fe9219dcab760e0a4a33c626e36984"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.15.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2c29dcf1a472216dc2392462923ef28366ec16e95387a4edb9c4eecfbf02ee3b"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.15.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.15.0"
      sha256 "a56eff4827878a78326c3fc4f8e4a692118c747ad40248abf45af8f68200801a"
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
