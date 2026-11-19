class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.36.2/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "7d7f7803629038f34263edcd75e6ddc887bddd68f8cc1a4c3f189daea161c75e"
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
      url "https://fctl.sh/releases/v0.36.2/fctl-x86_64-apple-darwin.tar.gz"
      version "0.36.2"
      sha256 "7138a96284e1a2c53c01b4e29f77427672a09a7d99f6b9877a5059133f44d684"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.36.2/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "03815477ad682432d57e1333fc4f1c453e415e19d1d75056a51cd30f7865cec7"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.36.2/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.36.2"
      sha256 "e09fe9653c5e65d830c302fd67245f92eb8d9b274c67e4b0c739af8273160450"
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
