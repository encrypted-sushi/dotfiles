if status is-interactive
# Commands to run in interactive sessions can go here
  
  set -x SSH_AUTH_SOCK $HOME/.ssh/agent.sock

  # Only start if not already running
  if not test -S "$SSH_AUTH_SOCK"
    rm -f "$SSH_AUTH_SOCK"
    setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" \
        EXEC:"$HOME/.local/bin/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &
  end
end
