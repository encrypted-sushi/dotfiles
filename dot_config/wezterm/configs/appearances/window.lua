-- ~/.config/wezterm/configs/appearance/window.lua
local M = {}

function M.setup(config)
  -- Window aesthetics
  config.window_decorations = "RESIZE"
  config.enable_tab_bar = true
  config.tab_bar_at_bottom = true

  config.window_padding = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 0,
  }
end

return M
