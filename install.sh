#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[install] $1"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

brew_install() {
  if brew list --formula | grep -q "^$1$"; then
    log "$1 already installed (formula)"
  else
    log "Installing $1"
    brew install "$1"
  fi
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
if ! command_exists brew; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  log "Homebrew already installed"
fi

########################################
# Fish
########################################
brew_install fish

FISH_PATH="$(which fish)"

if ! grep -q "$FISH_PATH" /etc/shells; then
  log "Adding fish to /etc/shells"
  echo "$FISH_PATH" | sudo tee -a /etc/shells
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
# Tide (Fish prompt)
########################################
if ! fish -c "fisher list" | grep -q "tide"; then
  log "Installing Tide theme"
  fish -c "fisher install IlanCosman/tide@v6"
else
  log "Tide already installed"
fi

# Run tide configure only if not already configured
if [ ! -f "$HOME/.config/fish/conf.d/tide.fish" ] && [ ! -f "$HOME/.config/fish/tide/config.fish" ]; then
  log "Running Tide configuration (interactive)"
  fish -c "tide configure"
else
  log "Tide already configured"
fi

########################################
# Dotfiles config symlinks
########################################
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)/.config"

link_if_new() {
  local src="$1" dest="$2"

  if [ -L "$dest" ]; then
    log "${dest#$HOME/} symlink already exists"
    return
  fi
  if [ -e "$dest" ]; then
    rm "$dest"
    log "Removed existing ${dest#$HOME/}"
  fi
  ln -s "$src" "$dest"
  log "${dest#$HOME/} linked"
}

########################################
# Aerospace
########################################
log "Setting up aerospace config"

mkdir -p "$HOME/.config/aerospace"

link_if_new "$DOTFILES_DIR/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"

########################################
# Fish
########################################
log "Setting up fish config"

link_if_new "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
link_if_new "$DOTFILES_DIR/.fishrc" "$HOME/.fishrc"

########################################
# Neovim
########################################
log "Setting up neovim config"

for f in init.lua; do
  link_if_new "$DOTFILES_DIR/nvim/$f" "$HOME/.config/nvim/$f"
done

for d in lua/config lua/plugins; do
  if [ -L "$HOME/.config/nvim/$d" ]; then
    log "nvim/$d symlink already exists"
  else
    [ -d "$HOME/.config/nvim/$d" ] && rm -rf "$HOME/.config/nvim/$d"
    ln -s "$DOTFILES_DIR/nvim/$d" "$HOME/.config/nvim/$d"
    log "nvim/$d linked"
  fi
done

########################################
# opencode
########################################
log "Setting up opencode config"

OPENCODE_DIR="$HOME/.config/opencode"

mkdir -p "$OPENCODE_DIR"

for f in opencode.jsonc; do
  link_if_new "$DOTFILES_DIR/opencode/$f" "$OPENCODE_DIR/$f"
done

for d in agents skills; do
  if [ -L "$OPENCODE_DIR/$d" ]; then
    log "opencode/$d symlink already exists"
  else
    [ -d "$OPENCODE_DIR/$d" ] && rm -rf "$OPENCODE_DIR/$d"
    ln -s "$DOTFILES_DIR/opencode/$d" "$OPENCODE_DIR/$d"
    log "opencode/$d linked"
  fi
done

########################################
# Zed theme setup
########################################
log "Setting up Zed theme symlink"

mkdir -p "$HOME/.config/zed/themes"

if [ ! -L "$HOME/.config/zed/themes/cwal.json" ]; then
  if [ -f "$HOME/.cache/cwal/colors-zed.json" ]; then
    ln -s "$HOME/.cache/cwal/colors-zed.json" "$HOME/.config/zed/themes/cwal.json"
    log "Zed theme linked"
  else
    log "Warning: ~/.cache/cwal/colors-zed.json not found"
  fi
else
  log "Zed theme symlink already exists"
fi

########################################
# CLI tools
########################################
brew tap mhaeuser/mhaeuser
brew_install battery-toolkit
brew_install neovim
brew tap FelixKratz/formulae
brew install borders
brew tap darknesskiller/cwal
brew_install cwal
brew_install yazi
brew_install fzf
brew_install opencode

########################################
# GUI apps
########################################
brew_cask_install ghostty
brew_cask_install shottr
brew_cask_install jordanbaird-ice
brew_cask_install istat-menus
brew_cask_install linearmouse
brew_cask_install nikitabobko/tap/aerospace
brew_cask_install tabby
brew_cask_install zed
brew_cask_install vscodium
brew_cask_install font-meslo-for-powerlevel10k

########################################
# Mac App Store
########################################
if ! command_exists mas; then
  log "Installing mas CLI"
  brew_install mas
fi

mas_install 1352778147 "Bitwarden"
mas_install 1451685025 "WireGuard"

########################################
# JankyBorders setup
########################################
log "Setting up JankyBorders colors symlink"

mkdir -p "$HOME/.config/borders"

if [ -f "$HOME/.cache/cwal/bordersrc" ]; then
    ln -s "$HOME/.cache/cwal/bordersrc" "$HOME/.config/borders/bordersrc"
    log "JankyBorders theme linked"
  else
    log "Warning: ~/.cache/cwal/bordersrc not found"
fi

########################################
# Done
########################################
log "Setup complete"

GHOSTTY_THEME_PATH="$HOME/.cache/cwal/colors-ghostty.conf"

cat <<EOF

Next step: configure Ghostty manually

Add the following to your Ghostty config:

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

log "Run: chsh -s $(which fish) to set fish as default shell"
