class VideoCaptureMcp < Formula
  include Language::Python::Virtualenv

  desc "MCP server for macOS, iOS Simulator, and Android screen recording"
  homepage "https://github.com/Corvus400/video-capture-mcp"
  url "https://files.pythonhosted.org/packages/28/07/a87781ffb9fbbac27c71861211d4b92a73c9325bc30056fc3149324c0dc6/video_capture_mcp-0.1.0.tar.gz"
  sha256 "07d76d6313d03c32b2c6f3deeb4864fa8dc0587dfc873dde25d9c18aa24c6136"
  license "MIT"
  version "0.1.0"

  depends_on "ffmpeg"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "video_capture", shell_output("#{bin}/video-capture-mcp < /dev/null", 1)
  end
end
