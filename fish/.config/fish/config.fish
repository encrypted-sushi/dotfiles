# ~/.config/fish/config.fish

# Source my colors config for various things
if test -f $HOME/.config/fish/kanagawa-wave-colors.fish
    source $HOME/.config/fish/kanagawa-wave-colors.fish
end
# if test -f $HOME/.config/fish/catppuccin-mocha-colors.fish
#     source $HOME/.config/fish/catppuccin-mocha-colors.fish
# end

# Adding to path here so all machines can be synchronized
fish_add_path "$HOME/.local/bin" "/opt/sbin" "/opt/bin"

# Stupid prompt arrow backward fix?
# https://forum.endeavouros.com/t/solved-fish-prompt-arrow-backwards/77662/6
set -gx fish_key_bindings fish_hybrid_key_bindings

# SSH Agent Socket
set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock

# Eza
set -gx EZA_ICONS_AUTO 1

# Source aliases.fish file if it exists
if test -f $HOME/.config/fish/aliases.fish
    source $HOME/.config/fish/aliases.fish
end

# Source a local, machine-specific file if it exists (not in dotfiles)
if test -f $HOME/.config/fish/local.fish
    source $HOME/.config/fish/local.fish
end


