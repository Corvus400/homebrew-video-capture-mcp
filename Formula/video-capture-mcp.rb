class VideoCaptureMcp < Formula
  desc "MCP server for macOS, iOS Simulator, and Android screen recording"
  homepage "https://github.com/Corvus400/video-capture-mcp"
  url "https://files.pythonhosted.org/packages/e8/96/bcbace10f4a072667aaaf59085c695c6a08236f0b6326c45978e1fcbecf9/video_capture_mcp-0.2.1.tar.gz"
  sha256 "afbb44c7d35499381c4bb4240ad1b6b98571fe5c236e20150ea01d8a8311368a"
  license "MIT"
  version "0.2.1"

  depends_on "ffmpeg"
  depends_on "uv"

  def install
    (bin/"video-capture-mcp").write <<~SH
      #!/bin/bash
      exec "#{Formula["uv"].opt_bin}/uvx" "video-capture-mcp==0.2.1" "$@"
    SH
  end

  test do
    assert_match "video-capture-mcp==0.2.1", (bin/"video-capture-mcp").read
  end
end
