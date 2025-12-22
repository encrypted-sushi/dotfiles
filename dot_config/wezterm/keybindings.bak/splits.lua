-- configs/keybindings/splits.lua
local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

function M.setup(config)
  -- Add split-related keybindings to config.keys
  local split_keys = {
    -- Send Ctrl+a when pressed twice (for start of line in shell)
    { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },

    -- Split vertically (side by side)
    { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    
    -- Split horizontally (top and bottom)
    { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- Navigate between panes
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

    -- Close current pane
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

    -- Toggle pane zoom (fullscreen current pane)
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  }

  -- Initialize config.keys if it doesn't exist, then append
  config.keys = config.keys or {}
  for _, key in ipairs(split_keys) do
    table.insert(config.keys, key)
  end
end

return M
