set fish_greeting
set -gx GPG_TTY (tty)

# CachyOS
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# User functions
if test -f ~/.config/fish/bitwarden.fish
source ~/.config/fish/bitwarden.fish
end

if test -f ~/.config/fish/claudex.fish
source ~/.config/fish/claudex.fish
end

# User configuration
if test -f ~/.fishrc
    source ~/.fishrc
end
