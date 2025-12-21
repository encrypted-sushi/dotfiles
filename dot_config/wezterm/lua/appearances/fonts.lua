-- %USERPROFILE%\.config\wezterm\configs\fonts.lua
-- Font configuration with fallbacks and italic rules

local wezterm = require('wezterm')

local M = {}

function M.setup(config)
  -- Global font size
  config.font_size = 15.0

  -- Primary font with fallbacks
  config.font = wezterm.font_with_fallback {
    { 
      family = "VictorMono Nerd Font", 
      weight = "Medium",
      harfbuzz_features = {
        "liga=1",
        "calt=1",
        "ss04",    
      },
    },
    
    -- Fallback: CJK Font (Sarasa Gothic TTC Unhinted)
    { family = "Sarasa Gothic Ttc", weight = "Regular" }, 
  }

  -- Cursive italic blend (Victor Mono for italic text)
  -- abcdefghijklmnopqrstuvwxyz
  -- config.font_rules = {
  --   {
  --     italic = true,
  --     font = wezterm.font("VictorMono Nerd Font", { style = "Italic" }),
  --   },
  -- }
end

return M
