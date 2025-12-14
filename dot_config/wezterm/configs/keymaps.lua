local M = {}

function M.setup(config, wezterm)
  local act = wezterm.action
  
  -- 0. Keymaps (I probably need to start breaking this up soon)]
  config.keys = {
    -- Wezterm Copy Mode: Use Ctrl+Shift+[ to avoid conflict with tmux
    { key = ';', mods = 'CTRL', action = act.ActivateCopyMode },
  }
  
  config.key_tables = {
    copy_mode = {
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
      -- Half pages using a method taught to me by Claude AI
      { key = 'd', mods = 'CTRL', action = act.CopyMode { MoveByPage = 0.5 } },
      { key = 'u', mods = 'CTRL', action = act.CopyMode { MoveByPage = -0.5 } },
      
      -- Selection modes
      { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
      { key = 'V', mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' } },
  
      -- Copy with virual feedback?
      { 
        key = 'y', 
        mods = 'NONE', 
        action = wezterm.action_callback(function(window, pane)
          window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
          window:perform_action(act.CopyMode 'ClearPattern', pane)
          window:perform_action(act.CopyMode 'Close', pane)
        end)
      },
  
      -- Exit copy mode
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
    },
  }
end

return M
