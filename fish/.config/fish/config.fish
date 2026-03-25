# ~/.config/fish/config.fish

# Source my colors config for various things
if test -f $HOME/.config/fish/catppuccin-mocha-colors.fish
    source $HOME/.config/fish/catppuccin-mocha-colors.fish
end

# Stupid prompt arrow backward fix?
# https://forum.endeavouros.com/t/solved-fish-prompt-arrow-backwards/77662/6
set -gx fish_key_bindings fish_hybrid_key_bindings

# SSH Agent Socket
set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock

# Eza
set -gx EZA_ICONS_AUTO 1

# Tide
# Background/Base Colors
set -g tide_left_prompt_frame_color 585b70    # Surface 2
set -g tide_right_prompt_frame_color 585b70

# OS Icon & Directory (Your #89B4FA Blue)
set -g tide_os_icon_bg_color 89b4fa
set -g tide_pwd_bg_color 89b4fa
set -g tide_pwd_color_dirs 1e1e2e             # Base (Text on Blue)
set -g tide_pwd_color_anchors 1e1e2e           # Bolded parts of path

# Git Status (Your #A6E3A1 Green & #F9E2AF Yellow)
set -g tide_git_bg_color a6e3a1
set -g tide_git_bg_color_urgent f9e2af
set -g tide_git_color_branch 1e1e2e
set -g tide_git_color_dirty 1e1e2e

# Status Code (Your #F38BA8 Red for errors)
set -g tide_status_bg_color a6e3a1            # Green when success
set -g tide_status_bg_color_failure f38ba8    # Red when error


# Completion Pager Colors
set -g fish_pager_color_progress 6c7086 --background=313244
set -g fish_pager_color_prefix 89b4fa          # Blue (Your dir color)
set -g fish_pager_color_completion cdd6f4      # Text
set -g fish_pager_color_description 7f849c     # Gray (Your pipe/ignored color)

# Source aliases.fish file if it exists
if test -f $HOME/.config/fish/aliases.fish
    source $HOME/.config/fish/aliases.fish
end

# Source a local, machine-specific file if it exists (not in dotfiles)
if test -f $HOME/.config/fish/local.fish
    source $HOME/.config/fish/local.fish
end


