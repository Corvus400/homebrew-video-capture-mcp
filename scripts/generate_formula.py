from __future__ import annotations

import hashlib
import json
import re
import sys
import urllib.request
from pathlib import Path


PROJECT = "video-capture-mcp"
PACKAGE = "video_capture_mcp"
PYPI_JSON_URL = f"https://pypi.org/pypi/{PROJECT}/json"


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: generate_formula.py <release-tag>", file=sys.stderr)
        return 2
    tag = sys.argv[1]
    version = tag.removeprefix("v")
    if not re.fullmatch(r"\d+\.\d+\.\d+(?:[A-Za-z0-9.-]+)?", version):
        print(f"invalid version tag: {tag}", file=sys.stderr)
        return 2

    sdist_url = _sdist_url(version)
    sha256 = _sha256(sdist_url)
    formula_dir = Path("Formula")
    formula_dir.mkdir(exist_ok=True)
    (formula_dir / "video-capture-mcp.rb").write_text(
        _formula(version, sdist_url, sha256),
        encoding="utf-8",
    )
    return 0


def _sdist_url(version: str) -> str:
    with urllib.request.urlopen(PYPI_JSON_URL, timeout=30) as response:
        payload = json.load(response)
    for file_info in payload["releases"].get(version, []):
        if file_info.get("packagetype") == "sdist":
            return str(file_info["url"])
    raise RuntimeError(f"no sdist found for {PROJECT} {version}")


def _sha256(url: str) -> str:
    digest = hashlib.sha256()
    with urllib.request.urlopen(url, timeout=60) as response:
        while chunk := response.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def _formula(version: str, sdist_url: str, sha256: str) -> str:
    return f'''class VideoCaptureMcp < Formula
  include Language::Python::Virtualenv

  desc "MCP server for macOS, iOS Simulator, and Android screen recording"
  homepage "https://github.com/Corvus400/video-capture-mcp"
  url "{sdist_url}"
  sha256 "{sha256}"
  license "MIT"
  version "{version}"

  skip_clean "libexec"

  depends_on "ffmpeg"
  depends_on "python@3.12"

  def install
    virtualenv_create(libexec, "python3.12")
    system "python3.12", "-m", "pip", "--python=#{{libexec}}", "install", "."
    bin.install_symlink libexec/"bin/video-capture-mcp"
  end

  test do
    assert_match "video-capture-mcp", shell_output("#{{bin}}/pip show video-capture-mcp")
    assert_match "mcp", shell_output("#{{bin}}/pip show mcp")
  end
end
'''


if __name__ == "__main__":
    raise SystemExit(main())
