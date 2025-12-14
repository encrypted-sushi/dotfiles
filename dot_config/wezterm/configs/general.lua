local M = {}

function M.setup(config, wezterm)
  -- Set the default shell to the newly installed Nushell (nu.exe)
  config.default_prog = { 'pwsh' }
  
  -- Confirm when closing
  config.window_close_confirmation = 'AlwaysPrompt'
  config.skip_close_confirmation_for_processes_named = {}
  
end

return M

