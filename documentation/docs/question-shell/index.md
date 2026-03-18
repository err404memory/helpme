# question shell

`question` is a shell-native scratchpad helper for things that are too important to lose and too unfinished to force into a bigger system first.

It is designed as a sister tool to `helpme`, not as part of `helpme`.

- `helpme` is a terminal editing shell over a MkDocs documentation tree.
- `question` is a capture-and-triage shell over a Markdown scratchpad file.

## Workflow

1. Run `question`
2. Capture a loose end, question, or follow-up note
3. Save it into a simple state such as `open`, `next`, or `parked`
4. Choose the next likely action:
   - capture another
   - review today's entries
   - open the full file
5. Return later to review, search, or change state

## What `question` can do

- Capture entries into one Markdown scratchpad file
- Group entries by day under Markdown headings
- Tag entries with hashtags
- Review entries by state
- Search entries by free text
- Browse by tag
- Change state without opening the full file
- Add notes to existing entries
- Open the file or jump straight into the editor when needed

## Source Of Truth

- Shell: `documentation/tools/question/question`
- Data file: `QUESTION_FILE`
- Default data file: `~/.config/question/questions.md`

## Why it stays separate

`question` is not a docs navigator.

It exists for volatile notes, next actions, unclear asks, and half-formed tasks. That makes it a better future fit for downstream scratchpad or workflow ingestion than for the MkDocs documentation tree itself.

## Commands

```bash
question
question add "draft follow-up note"
question review
question find auth
question today
question tags
question open
question path
question doctor
```

## State Model

- `open`
- `next`
- `waiting`
- `parked`
- `done`
- `dropped`

Keep the states small and action-oriented. The goal is to support returnability, not taxonomy.

## Android / Termux Direction

The ideal Android UX is:

- non-fullscreen
- shell-native
- lightweight picker flow
- forgiving re-prompts

The current version uses `gum` when available and a numbered fallback otherwise. A future Android-first backend can stay touch-friendlier without turning the tool into a heavyweight TUI.
