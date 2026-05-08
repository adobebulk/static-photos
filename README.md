# static-photos

A self-hosted photo gallery — static Hugo site with a private admin panel for managing photos from anywhere.

## Stack

| Layer | Tech | Why |
|---|---|---|
| Site generator | [Hugo](https://gohugo.io) | Blazing fast, no runtime, pure static output |
| CSS | [Tailwind CSS v3](https://tailwindcss.com) | Utility-first, great mobile experience |
| Lightbox | [PhotoSwipe v5](https://photoswipe.com) | Best-in-class, works perfectly on mobile |
| Admin panel | Node.js + Express | Lightweight, runs locally, zero cloud dependencies |
| Web server | [Caddy](https://caddyserver.com) | Auto-HTTPS, dead simple config |
| Remote access | [Tailscale](https://tailscale.com) (optional) | Secure private VPN — access admin from phone |

---

## Quick start (local dev)

### Prerequisites

```bash
brew install hugo node
```

### 1. Install dependencies

```bash
npm install          # Tailwind + concurrently (root)
cd admin && npm install && cd ..
```

### 2. Run in dev mode

```bash
npm run dev
```

This starts Tailwind in watch mode and `hugo server` simultaneously. Open http://localhost:1313.

### 3. Run the admin panel

```bash
node admin/server.js
```

Open http://localhost:3001. Create a series, upload photos, hit **Rebuild**.

---

## Deploying on Mac Mini

Run the setup script once after cloning:

```bash
bash scripts/setup.sh
```

This will:
- Install Hugo, Caddy, and Node via Homebrew
- Build Tailwind CSS and Hugo
- Register launchd agents so the admin panel and Caddy start on boot

Your gallery will be at **http://localhost** (or your Mac Mini's LAN IP).
The admin panel will be at **http://\<mac-mini-ip\>:3001** (LAN only by default).

---

## Remote access from your phone

Install [Tailscale](https://tailscale.com/download) on both your Mac Mini and your phone. Then you can reach the admin panel at `http://<tailscale-ip>:3001` from anywhere — no port forwarding, no VPN config, no exposure to the public internet.

---

## Repo structure

```
static-photos/
├── site/                    # Hugo site
│   ├── hugo.toml            # Site config — set your name here
│   ├── assets/css/          # Tailwind source CSS
│   ├── static/css/          # Generated CSS (gitignored)
│   ├── themes/gallery/      # Custom theme
│   │   └── layouts/         # HTML templates (index, project page, 404)
│   └── content/projects/    # Your photo series (one dir per series)
│       └── <series-slug>/
│           ├── index.md     # Title, description, date, draft status
│           └── *.jpg        # Photos live here
├── admin/                   # Admin panel
│   ├── server.js            # Express API + static server
│   ├── public/index.html    # Mobile-friendly admin UI
│   └── package.json
├── scripts/
│   ├── setup.sh             # Mac Mini one-time setup
│   └── rebuild.sh           # Manual rebuild shortcut
├── Caddyfile                # Web server config
├── package.json             # Root: Tailwind + dev scripts
└── tailwind.config.js
```

---

## Adding photos manually (via Claude Code)

```bash
# Create a new series
mkdir -p site/content/projects/my-series
cat > site/content/projects/my-series/index.md <<EOF
---
title: "My Series"
description: "Description here"
date: "2025-06-01"
cover: ""
draft: false
---
EOF

# Copy photos in, then rebuild
cp ~/Desktop/myphotos/*.jpg site/content/projects/my-series/
bash scripts/rebuild.sh
```

---

## Customising

- **Site title / your name**: edit `site/hugo.toml`
- **Colors / typography**: edit `site/assets/css/input.css` and `tailwind.config.js`
- **Nav links**: edit `site/themes/gallery/layouts/partials/header.html`
- **Admin port**: set `ADMIN_PORT` env var before starting the admin server

---

## Going public

1. Point a domain to your home IP (use [duckdns.org](https://duckdns.org) if your IP is dynamic)
2. Forward ports 80 and 443 on your router to the Mac Mini
3. Replace `:80` in the `Caddyfile` with your domain — Caddy auto-provisions TLS

---

## Cowork + Claude Code workflow

| Task | Tool |
|---|---|
| Scaffold features, redesign sections, plan architecture | **Cowork** |
| Live dev loop — `hugo server`, tweak CSS, fix a template | **Claude Code** in terminal |
| Upload photos, publish a series while traveling | **Admin panel** at :3001 |
| Quick file edits, git commits, running scripts | **Claude Code** |
