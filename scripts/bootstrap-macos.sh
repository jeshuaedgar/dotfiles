#!/usr/bin/env bash
set -euo pipefail

REPO="jeshuaedgar/dotfiles"

WARNINGS=0

log() {
  printf '[INFO] %s\n' "$*"
}

warn() {
  WARNINGS=$((WARNINGS + 1))
  printf '[WARN] %s\n' "$*"
}

error() {
  printf '[ERROR] %s\n' "$*" >&2
}

die() {
  error "$*"
  exit 1
}

on_error() {
  local exit_code="$1"
  local line_no="$2"
  error "Command failed (exit ${exit_code}) at line ${line_no}."
  exit "$exit_code"
}

trap 'on_error $? $LINENO' ERR

retry() {
  local attempts="$1"
  local delay_seconds="$2"
  shift 2

  local i
  for i in $(seq 1 "$attempts"); do
    if "$@"; then
      return 0
    fi

    if [ "$i" -lt "$attempts" ]; then
      warn "Command failed (attempt ${i}/${attempts}); retrying in ${delay_seconds}s: $*"
      sleep "$delay_seconds"
    fi
  done

  return 1
}

need_command() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1
}

ensure_macos() {
  if [ "$(uname -s)" != "Darwin" ]; then
    die "This bootstrap script supports macOS only."
  fi
}

ensure_network() {
  log "Checking network reachability..."
  retry 3 3 curl -fsSIL https://github.com >/dev/null
  retry 3 3 curl -fsSIL https://raw.githubusercontent.com >/dev/null
}

ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools already installed."
    return
  fi

  warn "Xcode Command Line Tools not found. Attempting automatic install..."

  local marker_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
  local clt_package=""

  touch "$marker_file"
  clt_package="$(softwareupdate -l 2>/dev/null | grep -E '\* Label: Command Line Tools' | sed 's/^\* Label: //' | tail -n 1 || true)"
  rm -f "$marker_file"

  if [ -n "$clt_package" ]; then
    log "Installing ${clt_package} via softwareupdate (sudo required)..."
    if sudo softwareupdate -i "$clt_package" --verbose; then
      log "Installed Xcode Command Line Tools via softwareupdate."
    else
      warn "Automatic softwareupdate install failed; falling back to interactive installer."
      xcode-select --install || true
    fi
  else
    warn "No Command Line Tools package found via softwareupdate; falling back to interactive installer."
    xcode-select --install || true
  fi

  log "Waiting for Xcode Command Line Tools installation to complete..."
  local waited=0
  local timeout=3600
  while ! xcode-select -p >/dev/null 2>&1; do
    sleep 10
    waited=$((waited + 10))
    if [ "$waited" -ge "$timeout" ]; then
      die "Xcode Command Line Tools installation did not complete in time. Re-run after installation finishes."
    fi
  done

  log "Xcode Command Line Tools detected."
}

setup_brew_env() {
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    return
  fi

  if [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    return
  fi
}

ensure_homebrew() {
  if need_command brew; then
    log "Homebrew already installed."
    setup_brew_env
    return
  fi

  log "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  setup_brew_env

  need_command brew || die "Homebrew installation finished but brew is not on PATH."
}

ensure_core_tools() {
  log "Installing core bootstrap tools (git, curl, chezmoi)..."
  retry 3 3 brew update >/dev/null
  retry 3 3 brew install git curl chezmoi
}

chezmoi_init_and_apply() {
  log "Running chezmoi init for ${REPO}..."
  chezmoi init --apply --init --ssh "$REPO"

  log "Running second chezmoi apply pass for first-run reliability..."
  chezmoi apply --init
}

run_self_checks() {
  log "Running post-bootstrap self-checks..."

  local required_cmds
  required_cmds=(brew git curl chezmoi zsh)
  local cmd
  for cmd in "${required_cmds[@]}"; do
    if need_command "$cmd"; then
      log "Found command: ${cmd}"
    else
      die "Missing required command after bootstrap: ${cmd}"
    fi
  done

  if need_command mise; then
    log "Found command: mise"
  else
    warn "mise is not available on PATH yet. Open a new shell and run 'command -v mise'."
  fi

  if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Found external dependency: ~/.oh-my-zsh"
  else
    warn "~/.oh-my-zsh is missing. Re-run 'chezmoi apply --init'."
  fi

  if ssh-add -L >/dev/null 2>&1; then
    log "SSH agent has loaded identities."
  else
    warn "No SSH identities loaded in current session. If you use 1Password SSH agent, sign in and verify agent setup."
  fi

  if chezmoi doctor; then
    log "chezmoi doctor passed."
  else
    die "chezmoi doctor failed."
  fi
}

main() {
  if [ "$#" -gt 0 ]; then
    die "This script does not accept arguments. It bootstraps ${REPO} automatically."
  fi

  ensure_macos
  ensure_network
  ensure_xcode_clt
  ensure_homebrew
  ensure_core_tools
  chezmoi_init_and_apply
  run_self_checks

  printf '\n'
  log "Bootstrap complete."
  if [ "$WARNINGS" -gt 0 ]; then
    warn "Completed with ${WARNINGS} warning(s). Review warnings above for optional/manual follow-up."
  else
    log "All checks passed without warnings."
  fi
}

main "$@"
