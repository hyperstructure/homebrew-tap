class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.10.1/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "16856939033524cd4e3a491924fc4445b0b2898c54b630cccb4fb4f2bc375233"
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
      url "https://fctl.sh/releases/v0.10.1/fctl-x86_64-apple-darwin.tar.gz"
      version "0.10.1"
      sha256 "5afec646f885ca59d3463210082a45dc4406a82e617cd22305849c3e3be24a70"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.10.1/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "76ec7b9412d9c48d83c87d10ef608f0719f31b77ab93316f1fe56bdb7b799608"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.10.1/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.10.1"
      sha256 "b8bf9c58864f18d54c8abb19fd8327e4580c9b417639bd7c4b9f44cea0871049"
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
