class Fctl < Formula
  desc "Software factory for Claude Code: agents in sandboxes on your own machine"
  homepage "https://fctl.sh"
  url "https://fctl.sh/releases/v0.7.0/fctl-x86_64-unknown-linux-musl.tar.gz"
  sha256 "661a5ebb1798bb0788706d5c8a85cc1e924d47487ecec42c5bc0d5c4701294cf"
  license "MIT"

  livecheck do
    url "https://fctl.sh/releases/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    on_arm do
      url "https://fctl.sh/releases/v0.7.0/fctl-aarch64-apple-darwin.tar.gz"
      sha256 "5942fb24994035538ebc518c68314d6e4336d8ce5197dbf39078cfa07d4d7d59"
    end
    on_intel do
      url "https://fctl.sh/releases/v0.7.0/fctl-x86_64-apple-darwin.tar.gz"
      sha256 "9ebe07d66a9ef772911a513db4a88ba1c6be2a4f66a428b82a4c52531edc417d"
    end
  end

  on_linux do
    on_arm do
      url "https://fctl.sh/releases/v0.7.0/fctl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ed8b1c9beb7db36716eb11bee2759814aff2be432b5b892d94125f3f00cc74a0"
    end
  end

  def install
    # The archive carries fctl and the Linux agent that sandboxes run
    # (fctl-agent-<arch>-linux); fctl looks for the agent next to itself.
    bin.install "fctl"
    bin.install Dir["fctl-agent-*-linux"]

    generate_completions_from_executable(bin/"fctl", "completions", shell_parameter_format: :arg)
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
