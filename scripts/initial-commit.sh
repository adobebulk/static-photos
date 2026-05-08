#!/usr/bin/env bash
# Run this once to create a clean initial commit history.
# Usage: bash scripts/initial-commit.sh
set -e
cd "$(git rev-parse --show-toplevel)"

# Remove stale lock if present
rm -f .git/index.lock

git add .gitignore
git commit -m "chore: add .gitignore"

git add tailwind.config.js package.json site/assets/css/input.css
git commit -m "build: add Tailwind CSS v3 setup"

git add site/hugo.toml site/content/
git commit -m "feat: scaffold Hugo site with projects content structure"

git add site/themes/
git commit -m "feat: add custom gallery theme with PhotoSwipe lightbox"

git add admin/
git commit -m "feat: add Node.js admin panel with upload/publish API"

git add Caddyfile scripts/ README.md
git commit -m "chore: add Caddyfile, setup scripts, and README"

echo ""
echo "✓ All commits created. Run 'git log --oneline' to verify."
echo "  Then: git push"
