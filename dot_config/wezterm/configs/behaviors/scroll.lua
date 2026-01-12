-- ~/config/wezterm/configs/behaviors/scroll.lua
local M = {}

function M.setup(config)
  -- Force scrollback buffer
  config.scrollback_lines = 10000

  -- I don't want scrollbars
  config.enable_scroll_bar = false

  -- Ensure alternate screen scrollback is preserved (can't scroll after Neovim fix)
  config.alternate_buffer_wheel_scroll_speed = 1

  -- ADD THIS: 
  -- If you find yourself stuck, holding SHIFT while scrolling 
  -- will bypass any app logic and force the terminal to scroll.
  config.bypass_mouse_reporting_modifiers = 'SHIFT'
  
  -- ADD THIS (Windows Specific):
  -- Helps prevent the alternate screen from "eating" the scrollback
  -- when switching between pwsh and TUIs.
  config.hide_mouse_cursor_when_typing = false
end

return M
