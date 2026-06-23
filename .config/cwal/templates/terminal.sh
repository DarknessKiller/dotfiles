 # Set terminal colors script - Generated for cwal

# Colors 0-15
printf "\033]4;0;{color0}\033\\"
printf "\033]4;1;{color1}\033\\"
printf "\033]4;2;{color2}\033\\"
printf "\033]4;3;{color3}\033\\"
printf "\033]4;4;{color4}\033\\"
printf "\033]4;5;{color5}\033\\"
printf "\033]4;6;{color6}\033\\"
printf "\033]4;7;{color7}\033\\"
printf "\033]4;8;{color8}\033\\"
printf "\033]4;9;{color9}\033\\"
printf "\033]4;10;{color10}\033\\"
printf "\033]4;11;{color11}\033\\"
printf "\033]4;12;{color12}\033\\"
printf "\033]4;13;{color13}\033\\"
printf "\033]4;14;{color14}\033\\"
printf "\033]4;15;{color15}\033\\"

# Special colors
printf "\033]10;{foreground}\033\\"   # foreground
printf "\033]11;{background}\033\\"   # background
printf "\033]12;{cursor}\033\\"       # cursor
printf "\033]708;{border}\033\\"      # border

# FZF colors
export FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --color fg:7,bg:0,hl:1,fg+:232,bg+:1,hl+:255
    --color info:7,prompt:2,spinner:1,pointer:232,marker:1
"

# Fix LS_COLORS being unreadable.
export LS_COLORS="$LS_COLORS:su=30;41:ow=30;42:st=30;44:"
