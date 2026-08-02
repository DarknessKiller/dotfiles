source /usr/share/cachyos-fish-config/cachyos-config.fish
set fish_greeting

# User functions
if test -f ~/.config/fish/functions.fish
source ~/.config/fish/functions.fish
end

# User configuration
if test -f ~/.fishrc
    source ~/.fishrc
end

if status is-interactive; and test $COLUMNS -ge 150; and test $LINES -ge 35
    fastfetch
end
