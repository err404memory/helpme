# Termux setup

This is the lightest supported way to make `question` available from a Termux shell without hard-coding machine-specific paths.

## Assumptions

- the repo is cloned locally on Android
- your shell already loads `~/.bashrc.d/*.sh`
- you want repo-local public scripts plus local launchers

Example clone location:

```text
~/src/helpme
```

## Bootstrap

From the repo root:

```bash
./scripts/bootstrap-question.sh
```

That installs:

- `~/.local/bin/question-local`
- `~/.config/question-local/env`

Then add your own alias if you want `question` available globally:

```bash
alias question="$HOME/.local/bin/question-local"
```

## What it does

- keeps the repo copy as the public source of the script
- keeps machine-specific overrides in a local env file

## Recommended question config

Start with the default local file:

```bash
QUESTION_FILE="$HOME/.config/question/questions.md"
```

Later, if another scratchpad location becomes canonical, point `QUESTION_FILE` at that single source instead of creating a parallel file.

## Test

```bash
type question
question doctor
question add "termux setup check"
question today
```

## Notes

- `question` does not depend on any docs tree and can keep working on its own.
- The Android-specific picker backend is still a next step; for now `question` uses `gum` when available and a numbered fallback otherwise.
