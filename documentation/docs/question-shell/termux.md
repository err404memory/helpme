# Termux setup

This is the lightest supported way to make both `helpme` and `question` available from a Termux shell without hard-coding machine-specific paths.

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
./scripts/bootstrap-termux.sh
```

That installs:

- `~/.local/bin/helpme-local`
- `~/.local/bin/question-local`
- `~/.bashrc.d/35-helpme-question.sh`
- `~/.config/helpme-local/env`
- `~/.config/question-local/env`

Reload your shell after that.

## What it does

- adds `helpme` and `question` aliases through a shell snippet
- keeps the repo copy as the public source of the scripts
- keeps machine-specific overrides in local env files

## Recommended question config

Start with the default local file:

```bash
QUESTION_FILE="$HOME/.config/question/questions.md"
```

Later, if another scratchpad location becomes canonical, point `QUESTION_FILE` at that single source instead of creating a parallel file.

## Test

```bash
type helpme
type question
question doctor
question add "termux setup check"
question today
```

## Notes

- `helpme` works against the repo checkout you cloned onto the phone.
- `question` does not depend on the docs tree and can keep working even if the rendered docs are unavailable.
- The Android-specific picker backend is still a next step; for now `question` uses `gum` when available and a numbered fallback otherwise.
