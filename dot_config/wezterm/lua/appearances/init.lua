-- configs/appearances/init.lua
local M = {}

function M.setup(config)
  require('lua.appearances.window').setup(config)
  require('lua.appearances.fonts').setup(config)
end

return M
