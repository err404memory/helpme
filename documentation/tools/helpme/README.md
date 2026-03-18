# helpme

`helpme` is a terminal editing shell for the MkDocs reference tree in this repo.

It gives you a fast keyboard-first workflow for:

- browsing the docs nav with nested `gum` menus
- opening pages in `micro` or your preferred terminal editor
- jumping directly to headings inside a page
- creating, moving, copying, renaming, and deleting pages and groups
- opening rendered pages and copying source paths or rendered URLs

The rendered side is handled by MkDocs. `helpme` is the editing and navigation layer over the same Markdown files.

## Source of Truth

- nav: `documentation/mkdocs.yml`
- docs content: `documentation/docs/**/*.md`
- helpme shell: `documentation/tools/helpme/helpme`
- nav helper: `documentation/tools/helpme/helpme_nav.rb`
- MkDocs live server wrapper: `documentation/tools/mkdocs_live_server.py`

## Requirements

- `bash`
- `ruby`
- `gum` for the full interactive menu flow
- `micro` or another terminal editor

Without `gum`, `helpme` falls back to numbered prompts.

## Run

From a shell that can see the repo:

```bash
helpme
```

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

## Local Customization

The repo copy is intended to stay generic.

If you need host-specific renderer settings, keep them outside the repo in your local launcher or env file. The default local launcher path used in this setup is:

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

## Live Reload

The docs service uses `documentation/tools/mkdocs_live_server.py` instead of the plain `mkdocs serve` entrypoint. That wrapper uses MkDocs' `LiveReloadServer` directly with explicit watched paths so browser refresh works reliably for this mounted/shared setup.

## Notes

- `question` stays separate by design.
- The sister shell for fast capture and triage now lives at `documentation/tools/question/question`.
- The `pre-mvp-helpme` docs area is a stash of older topic notes that can be integrated gradually.
