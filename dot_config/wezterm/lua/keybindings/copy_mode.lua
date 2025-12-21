-- configs/keybindings/copy_mode.lua
local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

function M.setup(config)
  -- Keybinding to enter copy mode
  local copy_activation = {
    { key = ';', mods = 'CTRL', action = act.ActivateCopyMode },
  }

  -- Initialize config.keys and append
  config.keys = config.keys or {}
  for _, key in ipairs(copy_activation) do
    table.insert(config.keys, key)
  end

  -- Copy mode key table
  config.key_tables = config.key_tables or {}
  config.key_tables.copy_mode = {
    -- Navigation (Vim-style)
    { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },

    -- Word movement
    { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },

    -- Line movement
    { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },

    -- Page movement
    { key = 'd', mods = 'CTRL', action = act.CopyMode { MoveByPage = 0.5 } },
    { key = 'u', mods = 'CTRL', action = act.CopyMode { MoveByPage = -0.5 } },

    -- Selection modes
    { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
    { key = 'V', mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' } },

    -- Copy with notification
    {
      key = 'y',
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
        window:toast_notification('wezterm', '✓ Copied!', nil, 1000)
        window:perform_action(act.CopyMode 'ClearPattern', pane)
        window:perform_action(act.CopyMode 'Close', pane)
      end)
    },

    -- Exit copy mode
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
  }
end

return M
