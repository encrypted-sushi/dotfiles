# ~/.config/fish/config.fish
set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock

# Source a local, machine-specific file if it exists (not in dotfiles)
if test -f $HOME/.config/fish/local.fish
    source $HOME/.config/fish/local.fish
end
