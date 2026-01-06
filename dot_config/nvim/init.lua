-- ~/.config/nvim/init.lua
-- Load per-machine configurations if available
_G.MyConfigs = {}
local ok, result = pcall(function()
  return dofile(vim.fn.expand("$HOME/.config/nvim/local_config.lua"))
end)
if ok then
  _G.MyConfigs = result
end
require('config.core.options')
require('config.core.keymaps')
require('config.lazy')

