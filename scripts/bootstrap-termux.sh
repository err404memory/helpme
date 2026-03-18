#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

HELPER_BIN_DIR="${HELPER_BIN_DIR:-$HOME/.local/bin}"
BASHRC_D_DIR="${BASHRC_D_DIR:-$HOME/.bashrc.d}"
SHELL_SNIPPET="${SHELL_SNIPPET:-$BASHRC_D_DIR/35-helpme-question.sh}"

HELPME_INSTALL_BIN="${HELPME_INSTALL_BIN:-${HELPME_LOCAL_BIN:-$HELPER_BIN_DIR/helpme-local}}"
QUESTION_INSTALL_BIN="${QUESTION_INSTALL_BIN:-${QUESTION_LOCAL_BIN:-$HELPER_BIN_DIR/question-local}}"
HELPME_LOCAL_ENV_FILE="${HELPME_LOCAL_ENV_FILE:-$HOME/.config/helpme-local/env}"
QUESTION_LOCAL_ENV_FILE="${QUESTION_LOCAL_ENV_FILE:-$HOME/.config/question-local/env}"

ensure_dir() {
  mkdir -p "$1"
}

install_wrappers() {
  HELPME_INSTALL_BIN="$HELPME_INSTALL_BIN" \
    HELPME_LOCAL_ENV_FILE="$HELPME_LOCAL_ENV_FILE" \
    "$REPO_ROOT/scripts/bootstrap.sh" >/dev/null

  QUESTION_INSTALL_BIN="$QUESTION_INSTALL_BIN" \
    QUESTION_LOCAL_ENV_FILE="$QUESTION_LOCAL_ENV_FILE" \
    "$REPO_ROOT/scripts/bootstrap-question.sh" >/dev/null
}

write_shell_snippet() {
  cat >"$SHELL_SNIPPET" <<EOF
#!/usr/bin/env bash

export PATH="\$HOME/.local/bin:\$PATH"
alias helpme="$HELPME_INSTALL_BIN"
alias question="$QUESTION_INSTALL_BIN"
EOF

  chmod 644 "$SHELL_SNIPPET"
}

show_next_steps() {
  cat <<EOF
Installed Termux shell helpers:
  helpme launcher: $HELPME_INSTALL_BIN
  question launcher: $QUESTION_INSTALL_BIN
  shell snippet: $SHELL_SNIPPET
  helpme env: $HELPME_LOCAL_ENV_FILE
  question env: $QUESTION_LOCAL_ENV_FILE

Next steps:
  1. Ensure ~/.bashrc loads ~/.bashrc.d/*.sh
  2. Reload your shell
  3. Test:
     type helpme
     type question
     question doctor

Optional:
  - Edit $QUESTION_LOCAL_ENV_FILE to point QUESTION_FILE at a shared scratchpad
  - Edit $HELPME_LOCAL_ENV_FILE if you want non-default docs paths or site settings
EOF
}

main() {
  ensure_dir "$HELPER_BIN_DIR"
  ensure_dir "$BASHRC_D_DIR"
  ensure_dir "$(dirname "$HELPME_LOCAL_ENV_FILE")"
  ensure_dir "$(dirname "$QUESTION_LOCAL_ENV_FILE")"
  install_wrappers
  write_shell_snippet
  show_next_steps
}

main "$@"
