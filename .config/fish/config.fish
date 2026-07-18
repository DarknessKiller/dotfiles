source /usr/share/cachyos-fish-config/cachyos-config.fish
set fish_greeting

if test -f ~/.fishrc
    source ~/.fishrc
end

if status is-interactive; and test $COLUMNS -ge 150; and test $LINES -ge 35
    fastfetch
end
