#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[install] $1"
}

########################################
# Ensure paru exists
########################################
if ! command -v paru >/dev/null 2>&1; then
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
  pi-coding-agent
  ghostty
)

paru -S --needed "${PACKAGES[@]}"

########################################
# Fish (ensure available)
########################################
log "Ensuring fish is installed"

if ! command -v fish >/dev/null 2>&1; then
  log "Fish not found after install"
  exit 1
fi

########################################
# Set Fish as default shell
########################################

if command -v fish >/dev/null 2>&1; then
  FISH_PATH="$(command -v fish)"

  if [ "$SHELL" != "$FISH_PATH" ]; then
    log "Setting Fish as default shell"

    if grep -qx "$FISH_PATH" /etc/shells; then
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
fi

########################################
# Fisher
########################################
if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
  log "Installing Fisher"
  fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/fisher'
else
  log "Fisher already installed"
fi

########################################
# Tide
########################################
if ! fish -c "fisher list" | grep -q "^IlanCosman/tide"; then
  log "Installing Tide theme"
  fish -c "fisher install IlanCosman/tide@v6"
else
  log "Tide already installed"
fi

if [ ! -f "$HOME/.config/fish/conf.d/tide.fish" ] && \
   [ ! -f "$HOME/.config/fish/tide/config.fish" ]; then
  log "Running Tide configuration"
  fish -c "tide configure"
else
  log "Tide already configured"
fi

########################################
# Dotfiles config symlinks
########################################
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$REPO_DIR/.config"

link_if_new() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    log "${dest#$HOME/} already linked"
    return
  fi

  if [ -e "$dest" ]; then
    rm -rf "$dest"
    log "Removed existing ${dest#$HOME/}"
  fi

  ln -s "$src" "$dest"
  log "${dest#$HOME/} linked"
}

copy_if_missing() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    log "${dest#$HOME/} exists, leaving local copy"
    return
  fi

  cp "$src" "$dest"
  log "${dest#$HOME/} copied"
}

########################################
# Fish
########################################
log "Setting up Fish"

link_if_new \
  "$DOTFILES_DIR/fish/config.fish" \
  "$HOME/.config/fish/config.fish"

link_if_new \
  "$REPO_DIR/.fishrc" \
  "$HOME/.fishrc"

########################################
# Neovim
########################################
log "Setting up Neovim"

link_if_new \
  "$DOTFILES_DIR/nvim/init.lua" \
  "$HOME/.config/nvim/init.lua"

link_if_new \
  "$DOTFILES_DIR/nvim/lua/config" \
  "$HOME/.config/nvim/lua/config"

link_if_new \
  "$DOTFILES_DIR/nvim/lua/plugins" \
  "$HOME/.config/nvim/lua/plugins"

########################################
# Opencode
########################################
log "Setting up Opencode"

copy_if_missing \
  "$DOTFILES_DIR/opencode/opencode.jsonc" \
  "$HOME/.config/opencode/opencode.jsonc"

"$REPO_DIR/scripts/install-agent-skills.sh"

########################################
# Zed theme
########################################
log "Setting up Zed theme"

ZED_THEME_DIR="$HOME/.config/zed/themes"
CWAL_THEME="$HOME/.cache/cwal/colors-zed.json"

if [ -f "$CWAL_THEME" ]; then
  link_if_new "$CWAL_THEME" "$ZED_THEME_DIR/cwal.json"
else
  log "Warning: $CWAL_THEME not found"
fi

########################################
# Ghostty config
########################################
log "Configuring Ghostty"

GHOSTTY_THEME_PATH="$HOME/.cache/cwal/colors-ghostty.conf"

if [[ "$OSTYPE" == "darwin"* ]]; then
    GHOSTTY_CONFIG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
else
    GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
fi

GHOSTTY_CONFIG="$GHOSTTY_CONFIG_DIR/config.ghostty"

mkdir -p "$GHOSTTY_CONFIG_DIR"
touch "$GHOSTTY_CONFIG"

if ! grep -qF "# Added by install.sh" "$GHOSTTY_CONFIG"; then
  cat >>"$GHOSTTY_CONFIG" <<EOF

# Added by install.sh
theme = "$GHOSTTY_THEME_PATH"

# aesthetics
background-opacity = 0.85
background-blur = 16

# typography
font-size = 16
font-thicken = true
font-thicken-strength = 1
adjust-cell-height = 1
EOF

  log "Ghostty configured"
else
  log "Ghostty already configured"
fi

log "Done!"
