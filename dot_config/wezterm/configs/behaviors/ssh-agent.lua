-- ~/config/wezterm/configs/behaviors/ssh-agent.lua
local M = {}

function M.setup(config)
  local wezterm = require('wezterm')
  
  if wezterm.target_triple:find("windows") then
    -- 1. Tell WezTerm to use the standard Windows Named Pipe for SSH.
    -- This works for both 1Password and KeePassXC (with OpenSSH support enabled).
    config.default_ssh_auth_sock = [[\\.\pipe\openssh-ssh-agent]]
    
    -- 2. On Windows, we must set mux_enable_ssh_agent to false.
    -- If true, WezTerm creates a Unix-style socket proxy that Windows ssh.exe cannot read.
    -- Note: Remote Multiplexing still works! Even with this false, WezTerm uses the 
    -- local pipe for the initial handshake, then its internal protocol handles 
    -- "new shell on same host" logic for splits and tabs.
    config.mux_enable_ssh_agent = false
  else
    -- 3. On Linux/macOS, keep it true to allow WezTerm to manage the 
    -- SSH agent across multiplexed domains natively.
    config.mux_enable_ssh_agent = true
  end
end

return M
