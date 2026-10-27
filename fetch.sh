#!/usr/bin/env bash
# fetch.sh — 从 GitHub Releases 拉取指定版本的 HAP，并校验 sha256
# 用法：./fetch.sh [tag]      不传 tag 则拉最新
set -euo pipefail

REPO="2847181243-ops/kdevelop-ohos-artifacts"
TAG="${1:-}"

if ! command -v gh >/dev/null 2>&1; then
    echo "需要 GitHub CLI (gh)。装好后 gh auth login 一次即可。" >&2
    exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"

if [ -z "$TAG" ]; then
    gh release download --repo "$REPO" --pattern '*.hap' --dir "$TMP"
    gh release download --repo "$REPO" --pattern 'SHA256SUMS' --dir "$TMP" || true
else
    gh release download "$TAG" --repo "$REPO" --pattern '*.hap' --dir "$TMP"
    gh release download "$TAG" --repo "$REPO" --pattern 'SHA256SUMS' --dir "$TMP" || true
fi

if [ -f "$TMP/SHA256SUMS" ]; then
    (cd "$TMP" && sha256sum -c SHA256SUMS)
fi

for f in "$TMP"/*.hap; do
    [ -e "$f" ] || continue
    mv "$f" "$DIR/"
    echo "已保存：$DIR/$(basename "$f")"
done

rm -rf "$TMP"
