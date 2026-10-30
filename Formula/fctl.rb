class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.27.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "b3548443f725b75f1727cab89838ec2fc3f1277474e459bc5b3760efb302bb1c"
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
      url "https://fctl.sh/releases/v0.27.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.27.1"
      sha256 "8b825c9b684b4a66e0b9ab09ca31bd8ee3812ab9126bf30dfc434b2f4e12cb33"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.27.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c8014da5c779905c96db7cc09ae9219a22e518ea9fb843b7c413f3c19eaab8bd"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.27.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.27.1"
      sha256 "bed9902372883735c636854737041aae9bbbe36454c4f22346fe4d0a6c8c577d"
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
