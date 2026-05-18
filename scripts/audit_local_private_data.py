from __future__ import annotations

import re
import sys
from pathlib import Path


PATTERNS = [
    "today" + "amar",
    "type0" + "model52",
    r"/Users/[^/]+/Repository",
    "/private/" + "tmp",
    "claude" + "_tmp",
    "CONTEXT7" + "_API_KEY",
    "github" + "_pat_",
    "ghp" + "_",
    "HOMEBREW" + "_TAP_TOKEN",
]

SKIP_PARTS = {".git", "__pycache__"}


def main() -> int:
    regex = re.compile("|".join(PATTERNS))
    failures: list[str] = []
    for path in Path(".").rglob("*"):
        if not path.is_file() or SKIP_PARTS.intersection(path.parts):
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for line_no, line in enumerate(text.splitlines(), 1):
            if regex.search(line):
                failures.append(f"{path}:{line_no}: private/local pattern matched")
    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
