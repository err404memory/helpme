# question

`question` is a shell-native scratchpad helper for fast capture, review, and triage.

It is intentionally separate from `helpme`.

- `helpme` navigates and edits a MkDocs documentation tree.
- `question` captures loose ends, questions, small tasks, and follow-up notes in one Markdown file.

## Source of Truth

- question shell: `documentation/tools/question/question`
- backing file: `QUESTION_FILE` or `~/.config/question/questions.md`

## UX Goals

- capture-first workflow for volatile thoughts
- guided follow-up actions after save
- shell-native interaction through `gum` when available
- numbered fallback when `gum` is unavailable
- editor-driven escape hatch at every step

## Current Commands

```bash
question
question add "text"
question review
question find termux
question today
question tags
question open
question path
question doctor
```

For Termux wrapper setup from a local clone:

```bash
./scripts/bootstrap-termux.sh
```

## State Model

- `open`
- `next`
- `waiting`
- `parked`
- `done`
- `dropped`

Entries are stored in Markdown under daily headings and stay easy to grep or edit by hand.

## Editor Selection

`question` uses this priority order:

1. `QUESTION_EDITOR`
2. `micro`
3. `EDITOR`
4. `nano`, `vim`, `vi`

## Notes

- The first version keeps the storage format intentionally simple and plain-text friendly.
- Future Android improvements should prefer a lighter picker backend over a fullscreen TUI.
- Future dashboard or scratchpad integrations should read the same backing file rather than fork the data model.
