# helpme

`helpme` is a terminal-first editing shell for a MkDocs reference tree.

`question` is a separate shell-native scratchpad helper for capture, review, and state changes over a Markdown questions file.


## Included

- `documentation/tools/helpme/helpme`
- `documentation/tools/helpme/helpme_nav.rb`
- `documentation/tools/helpme/README.md`
- `documentation/tools/question/question`
- `documentation/tools/question/README.md`
- `documentation/tools/mkdocs_live_server.py`
- `documentation/mkdocs.yml`
- `documentation/docs/index.md`
- `documentation/docs/helpme-shell/index.md`
- `documentation/docs/question-shell/index.md`
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

If you want a local launcher plus an env file for your real docs tree:

```bash
./scripts/bootstrap.sh
```

That creates:

- `~/.local/bin/helpme-local`
- `~/.config/helpme-local/env`

For the scratchpad shell:

```bash
./scripts/bootstrap-question.sh
```

That creates:

- `~/.local/bin/question-local`
- `~/.config/question-local/env`

For a Termux-friendly setup that installs both wrappers and a shell snippet from one local clone:

```bash
./scripts/bootstrap-termux.sh
```

Then edit the env file, point it at your actual docs tree, and alias `helpme` to the wrapper if you want `helpme` available globally.

## Termux Installation

This is the clean setup flow for a fresh Android device in Termux.

### 1. Install packages

```bash
pkg update && pkg upgrade -y
pkg install -y bash git ruby gum micro ripgrep
```

### 2. Clone the repo

```bash
mkdir -p "$HOME/src"
git clone https://github.com/err404memory/helpme "$HOME/src/helpme"
cd "$HOME/src/helpme"
```

### 3. Make sure your shell loads `~/.bashrc.d/*.sh`

If your `~/.bashrc` does not already do this, add:

```bash
if [ -d "$HOME/.bashrc.d" ]; then
  for f in "$HOME/.bashrc.d"/*.sh; do
    [ -r "$f" ] && . "$f"
  done
fi
```

### 4. Bootstrap both shell helpers

```bash
./scripts/bootstrap-termux.sh
```

That creates:

- `~/.local/bin/helpme-local`
- `~/.local/bin/question-local`
- `~/.bashrc.d/35-helpme-question.sh`
- `~/.config/helpme-local/env`
- `~/.config/question-local/env`

### 5. Reload and verify

```bash
source "$HOME/.bashrc"
type helpme
type question
question doctor
```

### 6. Start using `question`

```bash
question
question add "first capture from android"
question today
```

By default, `question` uses:

```text
$HOME/.config/question/questions.md
```

You can later point `QUESTION_FILE` somewhere else in `~/.config/question-local/env` if you want a different canonical scratchpad location.

## Public Safety Check

Run the repo audit before publishing or opening a PR:

```bash
./scripts/public-safety-audit.sh
```

If you want a local pre-commit guard for staged files:

```bash
./scripts/install-public-safety-hook.sh
```

The audit scans for generic home-path leaks, SSH/scp-style host references, obvious secret-key markers, and suspicious local artifact filenames such as transcript dumps. If a match is intentional, add a path glob to `.public-safety-allowlist`. If you want the audit to catch your own machine names or local path fragments, put custom regex patterns in `.public-safety-local-patterns` and keep that file local only.

## Local Customization

If you need remote renderer controls or machine-specific defaults, keep them in local environment files outside the repo.

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
