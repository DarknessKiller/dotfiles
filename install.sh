# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install ITerm2
brew install --cask iterm2

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Battery Toolkit
brew tap mhaeuser/mhaeuser
brew install battery-toolkit

# Shottr
brew install --cask shottr

# Ice Bar
brew install --cask jordanbaird-ice

# IStat Menus 7
brew install --cask istat-menus

# LinearMouse
brew install --cask linearmouse

# Aerospace (i3 tiles)
brew install --cask nikitabobko/tap/aerospace

# Tabby
brew install --cask tabby

# MacOS App Store Apps
mas install 1352778147 # Bitwarden
mas install 1451685025 # Wireguard

# Zed Editor
brew install --cask zed

# VSCodium
brew install --cask vscodium

# Neovim
brew install neovim
