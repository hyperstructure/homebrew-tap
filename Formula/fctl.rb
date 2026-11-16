class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.35.2/fctl-aarch64-apple-darwin.tar.gz"
  sha256 "c8774eeb22f177de692d5db402184150bd762ff3eebd2a0988d71cb28a94f149"
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
      url "https://fctl.sh/releases/v0.35.2/fctl-x86_64-apple-darwin.tar.gz"
      version "0.35.2"
      sha256 "c307bef1d591901c0c8f83c1421830fc5ad6423db6c5f8553f7bcebef527096a"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.35.2/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "edc8761d61ce8d8f657b27806cdb8b4e116f728694847e605f0e501246383875"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.35.2/fctl-x86_64-unknown-linux-musl.tar.gz"
      version "0.35.2"
      sha256 "1626b9a4911347839a770a994c385c2a7ce89ca2224230db5a504e403e236d86"
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
