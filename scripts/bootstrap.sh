#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLIC_BIN="$REPO_ROOT/documentation/tools/helpme/helpme"
INSTALL_BIN="${HELPME_INSTALL_BIN:-$HOME/.local/bin/helpme-private}"
PRIVATE_ENV_FILE="${HELPME_PRIVATE_ENV_FILE:-$HOME/.config/helpme-private/env}"

ensure_dir() {
  mkdir -p "$1"
}

write_wrapper() {
  cat >"$INSTALL_BIN" <<EOF
#!/usr/bin/env bash
set -euo pipefail

PUBLIC_HELPME="\${HELPME_PUBLIC_BIN:-$PUBLIC_BIN}"
PRIVATE_ENV_FILE="\${HELPME_PRIVATE_ENV_FILE:-$PRIVATE_ENV_FILE}"

if [ ! -r "\$PUBLIC_HELPME" ]; then
  echo "Public helpme not found or not readable: \$PUBLIC_HELPME" >&2
  exit 1
fi

if [ -f "\$PRIVATE_ENV_FILE" ]; then
  mode="\$(stat -c '%a' "\$PRIVATE_ENV_FILE" 2>/dev/null || true)"
  if [ -n "\$mode" ] && [ "\$mode" -gt 600 ]; then
    echo "Refusing to load \$PRIVATE_ENV_FILE (permissions too open: \$mode)." >&2
    echo "Run: chmod 600 \$PRIVATE_ENV_FILE" >&2
    exit 1
  fi
  set -a
  . "\$PRIVATE_ENV_FILE"
  set +a
fi

exec bash "\$PUBLIC_HELPME" "\$@"
EOF

  chmod 755 "$INSTALL_BIN"
}

write_env_template() {
  if [ -e "$PRIVATE_ENV_FILE" ]; then
    return 0
  fi

  cat >"$PRIVATE_ENV_FILE" <<'EOF'
# Private helpme overlay defaults

# Path to public helpme script
# HELPME_PUBLIC_BIN="$HOME/dev/helpme/documentation/tools/helpme/helpme"

# Point these at the docs tree you want helpme to edit.
# HELPME_DOCS_ROOT="$HOME/path/to/docs"
# HELPME_MKDOCS_FILE="$HOME/path/to/mkdocs.yml"
# HELPME_HOMELAB_ROOT="$HOME/path/to/repo"
# HELPME_DOCS_COMPOSE_FILE="$HOME/path/to/docker-compose.yml"
# HELPME_SITE_URL="http://127.0.0.1:18101"

# Optional remote renderer control.
# HELPME_REMOTE_RENDER_HOST="user@host"
# HELPME_REMOTE_HOMELAB_ROOT="/path/to/repo"
# HELPME_REMOTE_DOCS_COMPOSE_FILE="/path/to/docker-compose.yml"

# Optional editor override
# HELPME_EDITOR="micro"
EOF

  chmod 600 "$PRIVATE_ENV_FILE"
}

show_next_steps() {
  cat <<EOF
Installed:
  wrapper: $INSTALL_BIN
  private env: $PRIVATE_ENV_FILE

Next steps:
  1. Edit $PRIVATE_ENV_FILE
  2. Add this to your shell if needed:
     alias helpme='$INSTALL_BIN'
  3. Start the docs renderer:
     cd $REPO_ROOT
     docker compose up -d docs
EOF
}

main() {
  ensure_dir "$(dirname "$INSTALL_BIN")"
  ensure_dir "$(dirname "$PRIVATE_ENV_FILE")"
  write_wrapper
  write_env_template
  show_next_steps
}

main "$@"
