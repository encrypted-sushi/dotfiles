-- ~/config/wezterm/configs/behaviors/pasting.lua
local M = {}

function M.setup(config)
  -- This is the magic line that apparently avoid double line break when pasting on windows
  config.canonicalize_pasted_newlines = "LineFeed"
end

return M
