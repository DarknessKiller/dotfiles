set fish_greeting
set -gx GPG_TTY (tty)

# User functions
if test -f ~/.config/fish/functions.fish
source ~/.config/fish/functions.fish
end

# User configuration
if test -f ~/.fishrc
    source ~/.fishrc
end
