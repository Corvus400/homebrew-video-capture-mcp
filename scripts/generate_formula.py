from __future__ import annotations

import hashlib
import json
import re
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path


PROJECT = "video-capture-mcp"
PACKAGE = "video_capture_mcp"
PYPI_VERSION_JSON_URL = f"https://pypi.org/pypi/{PROJECT}/{{version}}/json"
PYPI_ATTEMPTS = 60
PYPI_DELAY_SECONDS = 10


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
    payload = _pypi_payload(version)
    for file_info in payload["urls"]:
        if file_info.get("packagetype") == "sdist":
            return str(file_info["url"])
    raise RuntimeError(f"no sdist found for {PROJECT} {version}")


def _pypi_payload(version: str) -> dict[str, object]:
    url = PYPI_VERSION_JSON_URL.format(version=version)
    last_error: BaseException | None = None
    for _ in range(PYPI_ATTEMPTS):
        try:
            with urllib.request.urlopen(url, timeout=30) as response:
                return json.load(response)
        except (urllib.error.HTTPError, urllib.error.URLError, TimeoutError) as error:
            last_error = error
            time.sleep(PYPI_DELAY_SECONDS)
    raise RuntimeError(f"PyPI metadata was not available for {PROJECT} {version}") from last_error


def _sha256(url: str) -> str:
    digest = hashlib.sha256()
    with urllib.request.urlopen(url, timeout=60) as response:
        while chunk := response.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def _formula(version: str, sdist_url: str, sha256: str) -> str:
    return f'''class VideoCaptureMcp < Formula
  desc "MCP server for macOS, iOS Simulator, and Android screen recording"
  homepage "https://github.com/Corvus400/video-capture-mcp"
  url "{sdist_url}"
  sha256 "{sha256}"
  license "MIT"
  version "{version}"

  depends_on "ffmpeg"
  depends_on "uv"

  def install
    (bin/"video-capture-mcp").write <<~SH
      #!/bin/bash
      exec "#{{Formula["uv"].opt_bin}}/uvx" "video-capture-mcp=={version}" "$@"
    SH
  end

  test do
    assert_match "video-capture-mcp=={version}", (bin/"video-capture-mcp").read
  end
end
'''


if __name__ == "__main__":
    raise SystemExit(main())
