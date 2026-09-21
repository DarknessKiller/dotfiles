set fish_color_autosuggestion 6c7086
set fish_color_cancel f38ba8 '--reverse'
set fish_color_command a6e3a1
set fish_color_comment 6c7086
set fish_color_cwd a6e3a1
set fish_color_cwd_root f38ba8
set fish_color_end f9e2af
set fish_color_error f38ba8
set fish_color_escape f5c2e7
set fish_color_host 89b4fa
set fish_color_host_remote 89b4fa
set fish_color_keyword f5c2e7
set fish_color_match --background={color1.strip}
set fish_color_normal cdd6f4
set fish_color_operator 94e2d5
set fish_color_option f9e2af
set fish_color_param 89b4fa
set fish_color_quote f9e2af
set fish_color_redirection f5c2e7
set fish_color_search_match --background={color1.strip}
set fish_color_selection --background={color1.strip}
set fish_color_status {color1.strip}
set fish_color_user a6e3a1

set fish_pager_color_background 1e1e2e
set fish_pager_color_completion cdd6f4
set fish_pager_color_description 6c7086
set fish_pager_color_prefix {color1.strip}
set fish_pager_color_progress 6c7086
set fish_pager_color_secondary_background 1e1e2e
set fish_pager_color_secondary_completion cdd6f4
set fish_pager_color_secondary_description 6c7086
set fish_pager_color_secondary_prefix {color1.strip}
set fish_pager_color_selected_background --background={color1.strip}
set fish_pager_color_selected_completion cdd6f4
set fish_pager_color_selected_description 6c7086
set fish_pager_color_selected_prefix {color1.strip}

# FZF colors
export FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --color fg:7,bg:0,hl:1,fg+:232,bg+:1,hl+:255
    --color info:7,prompt:2,spinner:1,pointer:232,marker:1
"

# Fix LS_COLORS being unreadable.
export LS_COLORS="$LS_COLORS:su=30;41:ow=30;42:st=30;44:"