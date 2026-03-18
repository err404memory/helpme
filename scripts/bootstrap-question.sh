#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLIC_BIN="$REPO_ROOT/documentation/tools/question/question"
INSTALL_BIN="${QUESTION_INSTALL_BIN:-${QUESTION_LOCAL_BIN:-$HOME/.local/bin/question-local}}"
LOCAL_ENV_FILE="${QUESTION_LOCAL_ENV_FILE:-$HOME/.config/question-local/env}"

ensure_dir() {
  mkdir -p "$1"
}

write_wrapper() {
  cat >"$INSTALL_BIN" <<EOF
#!/usr/bin/env bash
set -euo pipefail

PUBLIC_QUESTION="\${QUESTION_PUBLIC_BIN:-$PUBLIC_BIN}"
LOCAL_ENV_FILE="\${QUESTION_LOCAL_ENV_FILE:-$LOCAL_ENV_FILE}"

if [ ! -r "\$PUBLIC_QUESTION" ]; then
  echo "Public question not found or not readable: \$PUBLIC_QUESTION" >&2
  exit 1
fi

if [ -f "\$LOCAL_ENV_FILE" ]; then
  mode="\$(stat -c '%a' "\$LOCAL_ENV_FILE" 2>/dev/null || true)"
  if [ -n "\$mode" ] && [ "\$mode" -gt 600 ]; then
    echo "Refusing to load \$LOCAL_ENV_FILE (permissions too open: \$mode)." >&2
    echo "Run: chmod 600 \$LOCAL_ENV_FILE" >&2
    exit 1
  fi
  set -a
  . "\$LOCAL_ENV_FILE"
  set +a
fi

exec bash "\$PUBLIC_QUESTION" "\$@"
EOF

  chmod 755 "$INSTALL_BIN"
}

write_env_template() {
  if [ -e "$LOCAL_ENV_FILE" ]; then
    return 0
  fi

  cat >"$LOCAL_ENV_FILE" <<'EOF'
# Local question defaults

# Path to public question script
# QUESTION_PUBLIC_BIN="$HOME/dev/helpme/documentation/tools/question/question"

# Canonical backing file for entries
# QUESTION_FILE="$HOME/.config/question/questions.md"

# Optional editor override
# QUESTION_EDITOR="micro"

# Optional menu behavior
# QUESTION_MENU_ON_EMPTY=1
# QUESTION_DEFAULT_STATE="open"
EOF

  chmod 600 "$LOCAL_ENV_FILE"
}

show_next_steps() {
  cat <<EOF
Installed:
  launcher: $INSTALL_BIN
  local env: $LOCAL_ENV_FILE

Next steps:
  1. Edit $LOCAL_ENV_FILE
  2. Add this to your shell if needed:
     alias question='$INSTALL_BIN'
EOF
}

main() {
  ensure_dir "$(dirname "$INSTALL_BIN")"
  ensure_dir "$(dirname "$LOCAL_ENV_FILE")"
  write_wrapper
  write_env_template
  show_next_steps
}

main "$@"
