# helpme

`helpme` is a terminal-first shell for a structured Markdown notebook.

It is for the things you solve once and do not want to rediscover later: commands, aliases, setup notes, troubleshooting steps, and other reference pages you want close at hand in the terminal.

## Uses

- a personal command notebook
- alias and shell-customization reference pages
- personal reference notes
- project documentation and runbooks
- homelab or ops procedures
- troubleshooting notes and command guides
- internal team docs
- research notes or long-lived markdown knowledge bases

If your source of truth is a set of Markdown pages, `helpme` can provide the terminal workflow around that tree.

## Features

- browses a nav tree with nested `gum` menus
- edits Markdown pages in `micro` or another terminal editor
- jumps directly to Markdown headings
- creates, moves, copies, renames, and deletes pages and groups
- opens rendered docs pages and copies source paths or rendered URLs
- can work with an optional live preview service if you have one

## Fit

Best for:

- a terminal-native notebook for commands and workflows
- a structured place to keep “I solved this once already” knowledge
- fast navigation between related markdown pages
- something more personal and editable than manpages or app help output

Less useful for:

- a general notes app with no page structure
- a GUI-first documentation tool
- something that generates the content for you instead of helping you maintain it

## Compatibility

- **Primary target:** Linux shell environments
- **Likely works:** macOS, WSL, Termux
- **Not required:** any particular shell; `helpme` is a Bash script, not a terminal emulator plugin

Needs:

- `bash`
- `ruby`
- `gum` for the full interactive picker flow
- `micro` or another terminal editor

Without them:

- without `gum`, `helpme` falls back to numbered prompts
- without `micro`, set your preferred editor in your environment
- if you only want to edit docs and not preview them, you do not need any preview service
- if you want a persistent global command, use the bootstrap path instead of running the repo-local script directly

## Structure

`helpme` expects a docs root with:

- a directory of Markdown pages
- one navigation config file that defines page order and grouping
- a consistent place to edit and maintain that content

The exact nav file path is configurable in your launcher environment. You do not need to run any preview server or renderer to use the CLI itself.

A minimal shape looks like this:

```text
my-docs/
  documentation/
    docs/
      index.md
      shell/
        aliases.md
        git.md
      troubleshooting/
        ssh.md
    nav-config.yml
```

If you already keep structured Markdown pages somewhere, most of the setup is just pointing `helpme` at that tree.

## Start

Choose one path:

1. **Install a local launcher for your own docs tree**
Use this if you want `helpme` available globally against your own notebook.

2. **Try it from this repo**
Use this if you want to try `helpme` against the sample docs in this checkout.

3. **Use Termux on Android**
Use this only if you are setting it up inside Termux.

## Launcher

Use this if you want `helpme` to work against your own docs tree outside this checkout:

```bash
./scripts/bootstrap.sh
```

### Verify

- `~/.local/bin/helpme-local path` prints the docs root you configured
- `~/.local/bin/helpme-local` opens the menu
- opening a page edits the files from your configured docs tree

That creates:

- `~/.local/bin/helpme-local`
- `~/.config/helpme-local/env`

Then edit the env file so it points at your real docs tree.

If you want `helpme` available globally, add your own alias or shell function pointing at `helpme-local`.

This is the most generic path. It does not assume you use anything else in this repo.

## Repo

Run the CLI directly from the repo:

```bash
documentation/tools/helpme/helpme
```

### Verify

- the `helpme` menu opens
- you can browse the docs nav
- `documentation/tools/helpme/helpme path` resolves to this repo's docs tree

You can evaluate the notebook shell without any preview service at all.

## Preview

If you want a browser preview while testing this repo, you can start the included example service:

```bash
docker compose up -d docs
```

Then open:

```text
http://127.0.0.1:18101/
```

This preview service is optional. The core CLI does not depend on it.

## Termux

This is the setup flow for a fresh Android device in Termux.

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

### 4. Bootstrap the launcher

```bash
./scripts/bootstrap-termux.sh
```

That creates:

- `~/.local/bin/helpme-local`
- `~/.bashrc.d/35-helpme.sh`
- `~/.config/helpme-local/env`

### 5. Reload and verify

```bash
source "$HOME/.bashrc"
type helpme
helpme path
```

### 6. Start

Success criteria:

- `type helpme` resolves
- `helpme path` prints the configured docs root
- `helpme` opens the notebook menu

If you want browser preview later, you can add it separately. The Termux path does not depend on it.

## Layout

- `documentation/tools/helpme/helpme`
- `documentation/tools/helpme/helpme_nav.rb`
- `documentation/tools/helpme/README.md`
- `documentation/docs/index.md`
- `documentation/docs/helpme-shell/index.md`
- `documentation/docs/javascripts/path-copy.js`
- `documentation/docs/stylesheets/path-copy.css`
- `docker-compose.yml`

## Audit

Run the repo audit before publishing or opening a PR:

```bash
./scripts/public-safety-audit.sh
```

If you want a local pre-commit guard for staged files:

```bash
./scripts/install-public-safety-hook.sh
```

The audit scans for generic home-path leaks, SSH/scp-style host references, obvious secret-key markers, and suspicious local artifact filenames such as transcript dumps. If a match is intentional, add a path glob to `.public-safety-allowlist`. If you want it to check for your own machine names or local path fragments, put custom regex patterns in `.public-safety-local-patterns` and keep that file local only.

## Customization

If you need preview-service controls, remote rendering, or machine-specific defaults, keep them in local environment files outside the repo.

These integrations are optional. They are examples, not assumptions.

Useful variables:

```bash
HELPME_DOCS_ROOT
HELPME_HOMELAB_ROOT
HELPME_DOCS_COMPOSE_FILE
HELPME_SITE_URL
HELPME_REMOTE_RENDER_HOST
HELPME_REMOTE_HOMELAB_ROOT
HELPME_REMOTE_DOCS_COMPOSE_FILE
```
