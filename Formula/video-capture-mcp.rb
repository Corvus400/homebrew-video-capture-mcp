class VideoCaptureMcp < Formula
  desc "MCP server for macOS, iOS Simulator, and Android screen recording"
  homepage "https://github.com/Corvus400/video-capture-mcp"
  url "https://files.pythonhosted.org/packages/f8/86/bd5769453b940a33e79a91bc6020aaf9ebf956c46753c6b2ceae9f6c91a1/video_capture_mcp-0.2.0.tar.gz"
  sha256 "1f6f79ec77dfcddc4f227b867007678e6cd1c72fd8205a8dc4c1529b5aa93e94"
  license "MIT"
  version "0.2.0"

  depends_on "ffmpeg"
  depends_on "uv"

  def install
    (bin/"video-capture-mcp").write <<~SH
      #!/bin/bash
      exec "#{Formula["uv"].opt_bin}/uvx" "video-capture-mcp==0.2.0" "$@"
    SH
  end

  test do
    assert_match "video-capture-mcp==0.2.0", (bin/"video-capture-mcp").read
  end
end
