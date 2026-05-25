class VideoCaptureMcp < Formula
  desc "MCP server for macOS, iOS Simulator, and Android screen recording"
  homepage "https://github.com/Corvus400/video-capture-mcp"
  url "https://files.pythonhosted.org/packages/80/7c/2e6b5be10d2384fb601261a39b38aa0e9a229e1e2e1068bf6d79e85d588e/video_capture_mcp-0.5.1.tar.gz"
  sha256 "0b56da755dd898c22c28b9f6834a87dddec9426c4e4699be62b194ab274425eb"
  license "MIT"
  version "0.5.1"

  depends_on "ffmpeg"
  depends_on "uv"

  def install
    (bin/"video-capture-mcp").write <<~SH
      #!/bin/bash
      exec "#{Formula["uv"].opt_bin}/uvx" "video-capture-mcp==0.5.1" "$@"
    SH
  end

  test do
    assert_match "video-capture-mcp==0.5.1", (bin/"video-capture-mcp").read
  end
end
