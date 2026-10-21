class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.14.0/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "a64e2660497d324d2e25ea97859be0139a3acd2183d88bb354b2ee3c22dc523e"
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
      url "https://fctl.sh/releases/v0.14.0/fctl-x86_64-apple-darwin.tar.gz"
      version "0.14.0"
      sha256 "d35d48e582279d7eab95f6dc5e0d4e26794a2be14c7f9c5bdc21745a0ef8b87e"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.14.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dc9e988ebf8b579063baf8313c808aaa191f4c26dae0b820b2f854f743178717"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.14.0/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.14.0"
      sha256 "31b7a3e6b666b573533da49a2e3a6866105f4e63f06bcbeaa635c0812a3e9ca0"
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
