class VideoCaptureMcp < Formula
  desc "MCP server for macOS, iOS Simulator, and Android screen recording"
  homepage "https://github.com/Corvus400/video-capture-mcp"
  url "https://files.pythonhosted.org/packages/bd/d3/91203aa3e5eff5449407b12b5afc2c49326fb80ffd183b3e2d93d312e216/video_capture_mcp-0.4.0.tar.gz"
  sha256 "4f92c4ba249c45b927e55183c458bcffe0acfa6e1fec53bea03faa3e38100790"
  license "MIT"
  version "0.4.0"

  depends_on "ffmpeg"
  depends_on "uv"

  def install
    (bin/"video-capture-mcp").write <<~SH
      #!/bin/bash
      exec "#{Formula["uv"].opt_bin}/uvx" "video-capture-mcp==0.4.0" "$@"
    SH
  end

  test do
    assert_match "video-capture-mcp==0.4.0", (bin/"video-capture-mcp").read
  end
end
