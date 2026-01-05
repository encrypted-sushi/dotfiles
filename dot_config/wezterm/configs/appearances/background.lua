-- ~/.config/wezterm/configs/appearances/background.lua
local wezterm = require 'wezterm'
local M = {}

function M.setup(config)
  config.background = {
    {
      source = {
        -- Change this to the path of your image
        File = wezterm.home_dir .. '/.config/wezterm/assets/1358542.png',
      },
      -- This makes the image cover the whole window
      hsb = {
        -- Adjust this decimal (0.0 to 1.0) to dim the image
        -- 0.1 is very dark, 1.0 is full brightness
        brightness = 0.02, 
      },
      -- This controls how much the image "shows through"
      -- (1.0 is solid, lower is more see-through)
      opacity = 1.0, 
    },
  }

  -- Optional: This makes the actual text area slightly transparent 
  -- so the image behind it feels more "embedded"
  config.window_background_opacity = 0.90
end

return M
