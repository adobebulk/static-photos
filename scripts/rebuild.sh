#!/usr/bin/env bash
# Quick rebuild — CSS + Hugo. Run from anywhere inside the repo.
# Claude Code can call this directly: bash scripts/rebuild.sh
set -e
REPO="$(cd "$(dirname "$0")/.." && pwd)"
echo "→ Building CSS…"
npx --prefix "$REPO" tailwindcss \
  -i "$REPO/site/assets/css/input.css" \
  -o "$REPO/site/static/css/style.css" \
  --minify
echo "→ Building Hugo…"
hugo --source "$REPO/site" --minify
echo "✓ Done → $REPO/site/public"
