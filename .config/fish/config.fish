set fish_greeting
set -gx GPG_TTY (tty)

# CachyOS
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# User functions
if test -f ~/.config/fish/functions.fish
source ~/.config/fish/functions.fish
end

# User configuration
if test -f ~/.fishrc
    source ~/.fishrc
end
