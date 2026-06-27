# Catppuccin Macchiato + dynamic accents

set fish_color_autosuggestion {color8.strip}
set fish_color_cancel {color1.strip} '--reverse'
set fish_color_command {color10.strip}
set fish_color_comment {color8.strip}
set fish_color_cwd {color2.strip}
set fish_color_cwd_root {color1.strip}
set fish_color_end {color3.strip}
set fish_color_error {color1.strip}
set fish_color_escape {color5.strip}
set fish_color_history_current --bold
set fish_color_host {color12.strip}
set fish_color_host_remote {color12.strip}
set fish_color_keyword {color5.strip}
set fish_color_match --background=#363a4f
set fish_color_normal {foreground.strip}
set fish_color_operator {color6.strip}
set fish_color_option {color3.strip}
set fish_color_param {color12.strip}
set fish_color_quote {color11.strip}
set fish_color_redirection {color5.strip}
set fish_color_search_match --background=#363a4f
set fish_color_selection --background=#363a4f
set fish_color_status {color1.strip}
set fish_color_user {color10.strip}
set fish_color_valid_path --underline

set fish_pager_color_background #24273a
set fish_pager_color_completion {foreground.strip}
set fish_pager_color_description {color8.strip}
set fish_pager_color_prefix {color10.strip}
set fish_pager_color_progress {color8.strip}
set fish_pager_color_secondary_background #1e2030
set fish_pager_color_secondary_completion {foreground.strip}
set fish_pager_color_secondary_description {color8.strip}
set fish_pager_color_secondary_prefix {color10.strip}
set fish_pager_color_selected_background --background=#363a4f
set fish_pager_color_selected_completion {foreground.strip}
set fish_pager_color_selected_description {color8.strip}
set fish_pager_color_selected_prefix {color10.strip}

# FZF colors
export FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --color fg:7,bg:0,hl:1,fg+:232,bg+:1,hl+:255
    --color info:7,prompt:2,spinner:1,pointer:232,marker:1
"

# Fix LS_COLORS being unreadable.
export LS_COLORS="$LS_COLORS:su=30;41:ow=30;42:st=30;44:"