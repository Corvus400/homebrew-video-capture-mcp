class VideoCaptureMcp < Formula
  desc "MCP server for macOS, iOS Simulator, and Android screen recording"
  homepage "https://github.com/Corvus400/video-capture-mcp"
  url "https://files.pythonhosted.org/packages/12/be/8a7dc7a200ce68b580fd55b3bc5dd21030251d5aa81fc650e2787fc05dbd/video_capture_mcp-0.5.0.tar.gz"
  sha256 "a299aa36bab3c36d14a4a31dfdacc7a7b9fc6bc9abba467c5f451a152da4f14a"
  license "MIT"
  version "0.5.0"

  depends_on "ffmpeg"
  depends_on "uv"

  def install
    (bin/"video-capture-mcp").write <<~SH
      #!/bin/bash
      exec "#{Formula["uv"].opt_bin}/uvx" "video-capture-mcp==0.5.0" "$@"
    SH
  end

  test do
    assert_match "video-capture-mcp==0.5.0", (bin/"video-capture-mcp").read
  end
end
