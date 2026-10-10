#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

HELPER_BIN_DIR="${HELPER_BIN_DIR:-$HOME/.local/bin}"
BASHRC_D_DIR="${BASHRC_D_DIR:-$HOME/.bashrc.d}"
SHELL_SNIPPET="${SHELL_SNIPPET:-$BASHRC_D_DIR/35-helpme.sh}"
BASHRC_FILE="${BASHRC_FILE:-$HOME/.bashrc}"

HELPME_INSTALL_BIN="${HELPME_INSTALL_BIN:-${HELPME_LOCAL_BIN:-$HELPER_BIN_DIR/helpme-local}}"
HELPME_LOCAL_ENV_FILE="${HELPME_LOCAL_ENV_FILE:-$HOME/.config/helpme-local/env}"

REQUIRED_CMDS=(bash ruby)
OPTIONAL_CMDS=(gum micro termux-clipboard-set termux-open-url)

ensure_dir() {
  mkdir -p "$1"
}

pkg_for() {
  case "$1" in
    termux-clipboard-set|termux-open-url) printf 'termux-api\n' ;;
    *) printf '%s\n' "$1" ;;
  esac
}

check_deps() {
  local cmd missing_required=() missing_optional=()

  for cmd in "${REQUIRED_CMDS[@]}"; do
    command -v "$cmd" >/dev/null 2>&1 || missing_required+=("$(pkg_for "$cmd")")
  done
  for cmd in "${OPTIONAL_CMDS[@]}"; do
    command -v "$cmd" >/dev/null 2>&1 || missing_optional+=("$(pkg_for "$cmd")")
  done

  if [ "${#missing_required[@]}" -gt 0 ]; then
    printf 'Missing required packages: %s\n' "${missing_required[*]}" >&2
    printf 'Install them with:\n  pkg install -y %s\n' "${missing_required[*]}" >&2
    exit 1
  fi

  if [ "${#missing_optional[@]}" -gt 0 ]; then
    # termux-api appears once per missing command; dedupe for the hint.
    local unique
    unique="$(printf '%s\n' "${missing_optional[@]}" | sort -u | tr '\n' ' ')"
    printf 'Optional packages not installed: %s\n' "$unique"
    printf '  pkg install -y %s\n' "$unique"
    printf '  (termux-api also needs the Termux:API Android app for clipboard and URL opening)\n\n'
  fi
}

install_wrappers() {
  HELPME_INSTALL_BIN="$HELPME_INSTALL_BIN" \
    HELPME_LOCAL_ENV_FILE="$HELPME_LOCAL_ENV_FILE" \
    "$REPO_ROOT/scripts/bootstrap.sh" >/dev/null
}

write_shell_snippet() {
  cat >"$SHELL_SNIPPET" <<EOF
#!/usr/bin/env bash

export PATH="\$HOME/.local/bin:\$PATH"
export HELPME_SHELL_SNIPPET="$SHELL_SNIPPET"
alias helpme="$HELPME_INSTALL_BIN"
EOF

  chmod 644 "$SHELL_SNIPPET"
}

ensure_bashrc_loader() {
  if [ -f "$BASHRC_FILE" ] && grep -q '\.bashrc\.d' "$BASHRC_FILE"; then
    return 0
  fi

  cat >>"$BASHRC_FILE" <<'EOF'

# Load ~/.bashrc.d/*.sh (added by helpme bootstrap-termux.sh)
if [ -d "$HOME/.bashrc.d" ]; then
  for f in "$HOME/.bashrc.d"/*.sh; do
    [ -r "$f" ] && . "$f"
  done
  unset f
fi
EOF
  printf 'Added a ~/.bashrc.d loader to %s\n' "$BASHRC_FILE"
}

show_next_steps() {
  cat <<EOF
Installed Termux shell helpers:
  helpme launcher: $HELPME_INSTALL_BIN
  shell snippet: $SHELL_SNIPPET
  helpme env: $HELPME_LOCAL_ENV_FILE

Next steps:
  1. Reload your shell:
     source $BASHRC_FILE
  2. Test:
     type helpme
     helpme path

Optional:
  - Edit $HELPME_LOCAL_ENV_FILE to point helpme at your own docs tree
EOF
}

main() {
  check_deps
  ensure_dir "$HELPER_BIN_DIR"
  ensure_dir "$BASHRC_D_DIR"
  ensure_dir "$(dirname "$HELPME_LOCAL_ENV_FILE")"
  install_wrappers
  write_shell_snippet
  ensure_bashrc_loader
  show_next_steps
}

main "$@"
