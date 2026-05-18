class VideoCaptureMcp < Formula
  desc "MCP server for macOS, iOS Simulator, and Android screen recording"
  homepage "https://github.com/Corvus400/video-capture-mcp"
  url "https://files.pythonhosted.org/packages/02/d2/91aced417284c4a362aa6e8bde601d8bac1c67bda70e536bbf46c7c85f24/video_capture_mcp-0.1.1.tar.gz"
  sha256 "2c8b5c0c747369d886847fd445ef01adb1d908ffc1d8df20a3e42d5d59d9f199"
  license "MIT"
  version "0.1.1"

  depends_on "ffmpeg"
  depends_on "uv"

  def install
    (bin/"video-capture-mcp").write <<~SH
      #!/bin/bash
      exec "#{Formula["uv"].opt_bin}/uvx" "video-capture-mcp==0.1.1" "$@"
    SH
  end

  test do
    assert_match "video-capture-mcp==0.1.1", (bin/"video-capture-mcp").read
  end
end
