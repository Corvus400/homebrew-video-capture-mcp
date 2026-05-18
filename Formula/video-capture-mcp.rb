class VideoCaptureMcp < Formula
  desc "MCP server for macOS, iOS Simulator, and Android screen recording"
  homepage "https://github.com/Corvus400/video-capture-mcp"
  url "https://files.pythonhosted.org/packages/ff/69/38f631f6c0e3f4db560f66ba2d021330b004d11da8640df7d69c47fc1e1f/video_capture_mcp-0.3.0.tar.gz"
  sha256 "b27a47e4ac3d52f05c98370a1a9e1d9824307b1dc31cfc9d30011b9133171b61"
  license "MIT"
  version "0.3.0"

  depends_on "ffmpeg"
  depends_on "uv"

  def install
    (bin/"video-capture-mcp").write <<~SH
      #!/bin/bash
      exec "#{Formula["uv"].opt_bin}/uvx" "video-capture-mcp==0.3.0" "$@"
    SH
  end

  test do
    assert_match "video-capture-mcp==0.3.0", (bin/"video-capture-mcp").read
  end
end
