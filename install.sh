#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[install] $1"
}

brew_install_from_tap() {
  local tap="$1"
  local formula="$2"

  if ! brew tap | grep -qx "$tap"; then
    log "Tapping $tap"
    brew tap "$tap"
  fi

  if brew list --formula | grep -qx "$formula"; then
    log "$formula already installed"
    return
  fi

  log "Trusting $tap/$formula"
  brew trust "$tap/$formula"

  log "Installing $formula"
  brew install "$tap/$formula"
}

brew_install() {
  if brew list --formula | grep -q "^$1$"; then
    log "$1 already installed (formula)"
  else
    log "Installing $1"
    brew install "$1"
  fi
}

brew_cask_install_from_tap() {
  local tap="$1"
  local cask="$2"

  if ! brew tap | grep -qx "$tap"; then
    log "Tapping $tap"
    brew tap "$tap"
  fi

  if brew list --cask | grep -qx "$cask"; then
    log "$cask already installed"
    return
  fi

  log "Trusting $tap/$cask"
  brew trust "$tap/$cask"

  log "Installing $cask"
  brew install --cask "$tap/$cask"
}

brew_cask_install() {
  if brew list --cask | grep -q "^$1$"; then
    log "$1 already installed (cask)"
  else
    log "Installing $1"
    brew install --cask "$1"
  fi
}

mas_install() {
  local app_id="$1"
  local name="$2"

  if mas list | awk '{print $1}' | grep -q "^${app_id}$"; then
    log "$name already installed"
  else
    log "Installing $name"
    mas install "$app_id"
  fi
}

########################################
# Homebrew
########################################
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  log "Homebrew already installed"
fi

########################################
# CLI tools
########################################
log "Installing CLI tools"

brew_install fish
brew_install neovim
brew_install yazi
brew_install fzf
brew_install opencode
brew_install pi-coding-agent
brew_install borders

brew_install_from_tap \
  mhaeuser/mhaeuser \
  battery-toolkit

brew_install_from_tap \
  FelixKratz/formulae \
  borders

brew_install_from_tap \
  darknesskiller/cwal \
  cwal

########################################
# GUI apps
########################################
log "Installing GUI apps"

brew_cask_install ghostty
brew_cask_install shottr
brew_cask_install jordanbaird-ice
brew_cask_install istat-menus
brew_cask_install linearmouse
brew_cask_install tabby
brew_cask_install zed
brew_cask_install vscodium
brew_cask_install font-meslo-for-powerlevel10k

brew_cask_install_from_tap \
  nikitabobko/tap \
  aerospace

########################################
# Fish shell
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
# Aerospace
########################################
log "Setting up Aerospace"

link_if_new \
  "$DOTFILES_DIR/aerospace/aerospace.toml" \
  "$HOME/.config/aerospace/aerospace.toml"

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

link_if_new \
  "$HOME/.cache/cwal/colors-zed.json" \
  "$HOME/.config/zed/themes/cwal.json"

########################################
# JankyBorders
########################################
log "Setting up JankyBorders"

link_if_new \
  "$HOME/.cache/cwal/bordersrc" \
  "$HOME/.config/borders/bordersrc"

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

########################################
# Mac App Store
########################################
if ! command -v mas >/dev/null 2>&1; then
  log "Installing mas"
  brew_install mas
fi

mas_install 1352778147 "Bitwarden"
mas_install 1451685025 "WireGuard"

########################################
# Done
########################################
log "Done!"
