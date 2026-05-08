#!/usr/bin/env bash
# ─── Mac Mini setup script ────────────────────────────────────────────────────
# Run once after cloning the repo on your Mac Mini.
# Installs dependencies and sets up launchd services so everything
# starts automatically on boot.
#
# Usage:
#   cd /path/to/static-photos
#   bash scripts/setup.sh

set -e
REPO="$(cd "$(dirname "$0")/.." && pwd)"
echo "📷  Setting up photo gallery in: $REPO"

# ── 1. Homebrew dependencies ──────────────────────────────────────────────────
echo ""
echo "→ Checking Homebrew…"
if ! command -v brew &>/dev/null; then
  echo "  Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "→ Installing Hugo (extended)…"
brew install hugo || brew upgrade hugo

echo "→ Installing Caddy…"
brew install caddy || brew upgrade caddy

echo "→ Installing Node.js (if needed)…"
brew install node || true

# ── 2. Node dependencies ──────────────────────────────────────────────────────
echo ""
echo "→ Installing root npm packages (Tailwind, concurrently)…"
cd "$REPO" && npm install

echo "→ Installing admin panel npm packages…"
cd "$REPO/admin" && npm install

# ── 3. Build CSS & Hugo site ──────────────────────────────────────────────────
echo ""
echo "→ Building Tailwind CSS…"
cd "$REPO"
npx tailwindcss -i site/assets/css/input.css -o site/static/css/style.css --minify

echo "→ Building Hugo site…"
hugo --source "$REPO/site" --minify

# ── 4. Create launchd plists ──────────────────────────────────────────────────
PLIST_DIR="$HOME/Library/LaunchAgents"
mkdir -p "$PLIST_DIR"

# Admin panel service
cat > "$PLIST_DIR/com.photos.admin.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>             <string>com.photos.admin</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/bin/node</string>
    <string>${REPO}/admin/server.js</string>
  </array>
  <key>WorkingDirectory</key>  <string>${REPO}</string>
  <key>RunAtLoad</key>         <true/>
  <key>KeepAlive</key>         <true/>
  <key>StandardOutPath</key>   <string>${REPO}/logs/admin.log</string>
  <key>StandardErrorPath</key> <string>${REPO}/logs/admin.error.log</string>
</dict>
</plist>
PLIST

# Caddy service
cat > "$PLIST_DIR/com.photos.caddy.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>             <string>com.photos.caddy</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/bin/caddy</string>
    <string>run</string>
    <string>--config</string>  <string>${REPO}/Caddyfile</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>REPO_ROOT</key>       <string>${REPO}</string>
  </dict>
  <key>RunAtLoad</key>         <true/>
  <key>KeepAlive</key>         <true/>
  <key>StandardOutPath</key>   <string>${REPO}/logs/caddy.log</string>
  <key>StandardErrorPath</key> <string>${REPO}/logs/caddy.error.log</string>
</dict>
</plist>
PLIST

mkdir -p "$REPO/logs"

echo "→ Loading launchd agents…"
launchctl load "$PLIST_DIR/com.photos.admin.plist"  2>/dev/null || true
launchctl load "$PLIST_DIR/com.photos.caddy.plist"  2>/dev/null || true

echo ""
echo "✅  Done!"
echo ""
echo "   Gallery:      http://localhost"
echo "   Admin panel:  http://localhost:3001"
echo ""
echo "   Logs:         $REPO/logs/"
echo ""
echo "   Next steps:"
echo "   1. Open the admin panel and create your first series"
echo "   2. Upload some photos and hit 'Rebuild'"
echo "   3. Visit the gallery at http://localhost"
echo ""
echo "   For remote access from your phone, install Tailscale:"
echo "   https://tailscale.com/download"
