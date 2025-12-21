-- configs/general/init.lua
local M = {}

function M.setup(config)
  require('lua.general.shell').setup(config)
end

return M
