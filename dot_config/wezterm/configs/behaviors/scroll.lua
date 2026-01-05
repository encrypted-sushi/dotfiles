-- ~/config/wezterm/configs/behaviors/scroll.lua
local M = {}

function M.setup(config)
  -- Force scrollback buffer
  config.scrollback_lines = 10000

  -- I don't want scrollbars
  config.enable_scroll_bar = false

  -- Ensure alternate screen scrollback is preserved (can't scroll after Neovim fix)
  config.alternate_buffer_wheel_scroll_speed = 1
end

return M
