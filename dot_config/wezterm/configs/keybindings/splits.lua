-- ~/config/wezterm/configs/keybindings/splits.lua
local wezterm = require('wezterm')
local act = wezterm.action
local M = {}

function M.setup(config)
  -- Keybinding to enter split mode
  local split_activation = {
    { key = 'w', mods ='LEADER', action = act.ActivateKeyTable {
        name = 'split_mode',
        one_shot = false,
    }},
  }

  -- Initialize config.keys and append
  config.keys = config.keys or {}
  for _, key in ipairs(split_activation) do
    table.insert(config.keys, key)
  end


  -- Split mode key table
  config.key_tables = config.key_tables or {}
  config.key_tables.split_mode = {
    -- Window split/close/zoom/rotate
    -- Split vertically (side by side)
    { key = '|', mods = 'SHIFT', action = act.Multiple {
      act.SplitHorizontal { domain = 'CurrentPaneDomain' },
      act.PopKeyTable
    }},
    { key = 'v', mods = 'NONE', action = act.Multiple {
      act.SplitHorizontal { domain = 'CurrentPaneDomain' },
      act.PopKeyTable
    }},
    -- Split horizontally (top and bottom)
    { key = '-', mods = 'NONE', action = act.Multiple {
      act.SplitVertical { domain = 'CurrentPaneDomain' },
      act.PopKeyTable
    }},
    { key = 's', mods = 'NONE', action = act.Multiple {
      act.SplitVertical { domain = 'CurrentPaneDomain' },
      act.PopKeyTable
    }},
    -- Close current pane
    { key = 'c', mods = 'NONE', action = act.Multiple {
      act.CloseCurrentPane { confirm = true },
      act.PopKeyTable
    }},
    -- Toggle pane zoom (fullscreen current pane)
    { key = 'z', mods = 'NONE', action = act.Multiple {
      act.TogglePaneZoomState,
      act.PopKeyTable
    }},

    -- Navigation (Vim-style)
    { key = 'h', mods = 'NONE', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'NONE', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'NONE', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'NONE', action = act.ActivatePaneDirection 'Right' },

    -- Exit split mode
    { key = 'c', mods = 'CTRL', action = act.PopKeyTable },
    { key = 'Escape', mods = 'NONE', action = act.PopKeyTable },
  }

end

return M
