-- configs/keybindings/init.lua
local M = {}

function M.setup(config, wezterm)
  require('lua.keybindings.splits').setup(config)
  require('lua.keybindings.copy_mode').setup(config)
  require('lua.keybindings.tabs').setup(config)
end

return M
