set fish_greeting
set -gx GPG_TTY (tty)

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
