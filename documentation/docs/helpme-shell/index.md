# helpme shell

`helpme` is now the terminal editing shell for the MkDocs reference tree.

The generic repo version is path-relative, so it can run from any checkout location.

## Workflow

1. Run `helpme`
2. Navigate the `mkdocs.yml` nav with nested `gum` menus
3. Select a section for browse/reorg actions, or select a page to edit it in `micro`
4. Save and close the editor
5. Choose the next action from the follow-up menu

## What `helpme` can do

- Browse the MkDocs nav tree as nested `gum` menus
- Edit any rendered Markdown page in your preferred terminal editor
- Jump straight to Markdown headings inside a page and open `micro` at that line
- Create pages and subgroups directly from the menu flow
- Rename, move, and delete sections
- Rename, move, copy, and delete non-overview pages
- Open the rendered page or copy either the source path or rendered URL
- Copy rendered inline file paths in the browser with the new `Copy` pill
- Start or check the docs renderer from the root `helpme` menu
- Work directly against the same Markdown files that MkDocs renders
- Jump into config files for the docs stack and `helpme` itself
- Let the docs renderer rebuild and reload automatically after edits

## Source Of Truth

- Navigation: `documentation/mkdocs.yml`
- Content: `documentation/docs/**/*.md`
- Repo root: `<repo>/`

## Where Things Live

- Repo-local `helpme` shell: `documentation/tools/helpme/helpme`
- Repo-local nav helper: `documentation/tools/helpme/helpme_nav.rb`
- Shared docs content: `documentation/docs`
- Live-reload wrapper: `documentation/tools/mkdocs_live_server.py`

`question` is still separate for now and is not part of this docs tree.

## Why this setup exists

- Terminal editing is faster in the middle of active work
- MkDocs gives the same Markdown files a cleaner browse/read experience
- One shared source prevents note drift and duplicated versions

## Config Files To Know

- `documentation/mkdocs.yml`
- `documentation/docs/helpme-shell/index.md`
- `documentation/tools/helpme/helpme`
- `documentation/tools/helpme/helpme_nav.rb`
- `documentation/tools/helpme/README.md`
- `documentation/tools/mkdocs_live_server.py`
- `docker-compose.yml`
