class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.16.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "b689c395b7e94868f6bf72066d92a1000c0946225d1eb35fab5792009867da42"
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
      url "https://fctl.sh/releases/v0.16.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.16.1"
      sha256 "ca51568842aa76ad5b8c9e477bacb28769a16b07697e31eebdb105e9ee34f35b"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.16.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "928c50076468ffa24589e0392a673fcd9570f137b203c34d20ef7f50ea44caef"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.16.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.16.1"
      sha256 "9bba3159f23570dbf48c50dd836e111d0c01840764c23ab03ddb4f6745b02e3d"
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
