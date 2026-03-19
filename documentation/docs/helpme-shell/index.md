# helpme shell

`helpme` is a terminal notebook shell for structured Markdown reference pages.

The generic repo version is path-relative, so it can run from any checkout location.

## Uses

- command references you always forget
- aliases and shell customizations
- troubleshooting walkthroughs
- runbooks and procedures
- project-specific notes that need structure instead of one long scratch file
- any terminal-side notebook where “I know I solved this before” is a recurring problem

## Start

Use `helpme` in one of two ways:

1. Run the repo-local shell directly from a checkout
2. Install a local launcher that points at your own docs tree

If you only want to learn the flow, start with the repo-local shell first.

## Compatibility

- `bash` and `ruby` are required
- `gum` gives the full interactive picker flow
- without `gum`, `helpme` falls back to numbered prompts
- `micro` is the default editor, but any terminal editor can be used
- any preview service is optional if you only need editing and navigation

## Workflow

1. Run `helpme`
2. Navigate the configured nav tree with nested `gum` menus
3. Select a section for browse/reorg actions, or select a page to edit it
4. Save and close the editor
5. Choose the next action from the follow-up menu

## Verify

- the `helpme` menu opens
- `helpme path` resolves to the docs tree you expect
- editing a page changes the same Markdown file your docs tree uses

## Features

- Browse a nav tree as nested `gum` menus
- Edit any Markdown page in your preferred terminal editor
- Jump straight to Markdown headings inside a page and open `micro` at that line
- Create pages and subgroups directly from the menu flow
- Rename, move, and delete sections
- Rename, move, copy, and delete non-overview pages
- Open a preview page or copy either the source path or preview URL
- Copy rendered inline file paths in the browser with the new `Copy` pill
- Start or check a preview service from the root `helpme` menu
- Work directly against the same Markdown files your notebook uses
- Jump into config files for the notebook and `helpme` itself
- Let a preview service rebuild and reload automatically after edits

## Source

- Navigation config: `documentation/mkdocs.yml` (the nav file `helpme` reads today)
- Content: `documentation/docs/**/*.md`
- Repo root: `<repo>/`

## Layout

- Repo-local `helpme` shell: `documentation/tools/helpme/helpme`
- Repo-local nav helper: `documentation/tools/helpme/helpme_nav.rb`
- Shared docs content: `documentation/docs`
- Optional live preview wrapper: `documentation/tools/mkdocs_live_server.py`

## Why

- Terminal editing is faster in the middle of active work
- A page-based notebook is easier to revisit than guessing through `--help` output again
- One shared source prevents note drift and duplicated versions

## Files

- `documentation/mkdocs.yml`
- `documentation/docs/helpme-shell/index.md`
- `documentation/tools/helpme/helpme`
- `documentation/tools/helpme/helpme_nav.rb`
- `documentation/tools/helpme/README.md`
- `documentation/tools/mkdocs_live_server.py`
- `docker-compose.yml`
