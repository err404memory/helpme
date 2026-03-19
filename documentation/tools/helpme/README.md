# helpme

`helpme` is a terminal notebook shell for a structured Markdown reference tree.

It gives you a fast keyboard-first workflow for:

- browsing the docs nav with nested `gum` menus
- opening pages in `micro` or your preferred terminal editor
- jumping directly to headings inside a page
- creating, moving, copying, renaming, and deleting pages and groups
- opening preview pages and copying source paths or preview URLs

It is useful for command notes, aliases, runbooks, troubleshooting pages, and any other reference material you want to keep structured and easy to revisit from the terminal.

## Start

Use one of these paths:

1. run the repo-local script to try `helpme` against this checkout
2. install a local launcher if you want to point it at your own docs tree

If you are just evaluating the tool, start with the repo-local path first.

## Source

- nav config: `documentation/mkdocs.yml` (the nav file `helpme` reads today)
- docs content: `documentation/docs/**/*.md`
- helpme shell: `documentation/tools/helpme/helpme`
- nav helper: `documentation/tools/helpme/helpme_nav.rb`
- optional live preview wrapper: `documentation/tools/mkdocs_live_server.py`

## Requirements

- `bash`
- `ruby`
- `gum` for the full interactive menu flow
- `micro` or another terminal editor

Without `gum`, `helpme` falls back to numbered prompts.

## Compatibility

- tested target: Linux shell environments
- likely works: macOS, WSL, Termux
- if `gum` is missing, use the numbered fallback prompts
- if your editor is not `micro`, set a different editor in your environment
- if you do not need preview, you do not need the Docker docs service

## Repo

From a shell that can see the repo:

```bash
documentation/tools/helpme/helpme
```

### Verify

- the `helpme` menu opens
- `documentation/tools/helpme/helpme path` prints the docs root you expect

## Launcher

To install a local launcher plus env template:

```bash
./scripts/bootstrap.sh
```

Useful direct commands:

```bash
helpme
helpme list
helpme renderer
helpme start renderer
helpme status renderer
helpme config
helpme grep tmux
helpme path
```

The repo-local path is just a sample environment. The launcher path is the generic setup for your own notebook.

## Customization

The repo copy is intended to stay generic.

If you need host-specific preview settings, keep them outside the repo in your local launcher or env file. The default local launcher path used in this setup is:

```text
~/.local/bin/helpme-local
```

That launcher can load:

```text
~/.config/helpme-local/env
```

Example local values:

```bash
HELPME_REMOTE_RENDER_HOST=your-user@your-render-host
HELPME_REMOTE_HOMELAB_ROOT=/path/to/homelab
HELPME_REMOTE_DOCS_COMPOSE_FILE=/path/to/homelab/docker-compose.yml
HELPME_SITE_URL=http://your-docs-host:18101
```

## Preview

This repo includes an optional live preview wrapper at `documentation/tools/mkdocs_live_server.py`. If you use it, browser refresh stays reliable in this sample environment.

## Notes

- The `pre-mvp-helpme` docs area is a stash of older topic notes that can be integrated gradually.
