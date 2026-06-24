#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[install] $1"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

########################################
# Ensure paru exists
########################################
if ! command_exists paru; then
  log "paru is not installed. Please install it first."
  exit 1
fi

########################################
# Arch Linux packages
########################################
log "Installing Arch packages"

PACKAGES=(
  fish
  visual-studio-code-bin
  zed
  neovim
  yazi
  fzf
  opencode
)

paru -Sy "${PACKAGES[@]}"

########################################
# Fish (ensure available)
########################################
log "Ensuring fish is installed"

if ! command_exists fish; then
  log "Fish not found after install (unexpected)"
  exit 1
fi

########################################
# Set Fish as default shell
########################################

if command_exists fish; then
  FISH_PATH="$(command -v fish)"

  if [ "$SHELL" != "$FISH_PATH" ]; then
    log "Setting Fish as default shell"

    if grep -q "$FISH_PATH" /etc/shells; then
      chsh -s "$FISH_PATH" "$USER"
      log "Default shell changed to Fish"
    else
      log "Fish not in /etc/shells, adding it"

      echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
      chsh -s "$FISH_PATH" "$USER"

      log "Default shell changed to Fish"
    fi
  else
    log "Fish already default shell"
  fi
else
  log "Fish not installed, skipping shell change"
fi

########################################
# Fisher (Fish plugin manager)
########################################
if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
  log "Installing Fisher"
  fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/fisher'
else
  log "Fisher already installed"
fi

########################################
# Tide (Fish prompt)
########################################
if ! fish -c "fisher list" | grep -q "tide"; then
  log "Installing Tide theme"
  fish -c "fisher install IlanCosman/tide@v6"
else
  log "Tide already installed"
fi

# Configure Tide if not configured
if [ ! -f "$HOME/.config/fish/conf.d/tide.fish" ] && [ ! -f "$HOME/.config/fish/tide/config.fish" ]; then
  log "Running Tide configuration (interactive)"
  fish -c "tide configure"
else
  log "Tide already configured"
fi

########################################
# Zed theme setup (cwal symlink)
########################################
log "Setting up Zed theme symlink"

mkdir -p "$HOME/.config/zed/themes"

CWAL_THEME="$HOME/.cache/cwal/colors-zed.json"
ZED_THEME_LINK="$HOME/.config/zed/themes/cwal.json"

if [ -L "$ZED_THEME_LINK" ]; then
  log "Zed theme symlink already exists"
elif [ -f "$CWAL_THEME" ]; then
  ln -s "$CWAL_THEME" "$ZED_THEME_LINK"
  log "Zed theme linked"
else
  log "Warning: $CWAL_THEME not found"
fi