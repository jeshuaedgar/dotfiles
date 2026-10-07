#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[validate] %s\n' "$*"
}

die() {
  printf '[validate] ERROR: %s\n' "$*" >&2
  exit 1
}

need_command() {
  command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

need_command chezmoi
need_command git

SOURCE_DIR="$(chezmoi source-path)"
cd "$SOURCE_DIR"

log "doctor"
chezmoi doctor

log "render templates"
failed=0
while IFS= read -r -d '' tmpl; do
  if ! chezmoi execute-template --file "$tmpl" >/dev/null; then
    printf '[validate] ERROR: template failed: %s\n' "$tmpl" >&2
    failed=1
  fi
done < <(git ls-files -z -- '*.tmpl')

if [ "$failed" -ne 0 ]; then
  die "one or more templates failed to render"
fi

log "dry-run apply (scripts excluded)"
chezmoi apply --dry-run --verbose --no-tty --exclude=scripts

log "ok"
