# Local SSH Agent Socket (KeePassXC via npiperelay)
set -gx SSH_AUTH_SOCK $HOME/.ssh/keepassxc-agent.sock

# Start KeePassXC SSH agent bridge if not running
if not test -S $HOME/.ssh/keepassxc-agent.sock
    keepassxc.sh start 2>/dev/null
end
