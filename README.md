# helpme

`helpme` is a terminal-first editing shell for a MkDocs reference tree.

This branch is a sanitized public template extracted from a working private setup. It keeps the reusable tooling and docs flow while removing host-specific paths, usernames, and machine identities.

## Included

- `documentation/tools/helpme/helpme`
- `documentation/tools/helpme/helpme_nav.rb`
- `documentation/tools/helpme/README.md`
- `documentation/tools/mkdocs_live_server.py`
- `documentation/mkdocs.yml`
- `documentation/docs/index.md`
- `documentation/docs/helpme-shell/index.md`
- `documentation/docs/javascripts/path-copy.js`
- `documentation/docs/stylesheets/path-copy.css`
- `docker-compose.yml`

## What it does

- browses your MkDocs nav with nested `gum` menus
- edits Markdown pages in `micro` or another terminal editor
- jumps directly to Markdown headings
- creates, moves, copies, renames, and deletes pages and groups
- opens rendered docs pages and copies source paths or rendered URLs
- serves docs with real live reload through a custom MkDocs wrapper

## Quick Start

```bash
docker compose up -d docs
```

Then open:

```text
http://127.0.0.1:18101/
```

Run the CLI from the repo:

```bash
documentation/tools/helpme/helpme
```

Or point your own wrapper/alias at it.

## Bootstrap

If you want a private local wrapper plus an env file for your real docs tree:

```bash
./scripts/bootstrap.sh
```

That creates:

- `~/.local/bin/helpme-private`
- `~/.config/helpme-private/env`

Then edit the env file, point it at your actual docs tree, and alias `helpme` to the wrapper if you want `helpme` available globally.

## Private Overlay

The public repo copy stays generic. If you need remote renderer controls or local machine-specific defaults, keep them outside the repo via environment variables or a private launcher.

Useful variables:

```bash
HELPME_DOCS_ROOT
HELPME_MKDOCS_FILE
HELPME_HOMELAB_ROOT
HELPME_DOCS_COMPOSE_FILE
HELPME_SITE_URL
HELPME_REMOTE_RENDER_HOST
HELPME_REMOTE_HOMELAB_ROOT
HELPME_REMOTE_DOCS_COMPOSE_FILE
```
