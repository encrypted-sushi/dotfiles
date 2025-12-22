-- lua/keybindings/tabs.lua
local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

function M.setup(config)
  -- Add keybinding to ENTER tab mode
  local tab_keys = {
    { 
      key = 't',
      mods = 'LEADER', 
      action = act.ActivateKeyTable {
        name = 'tab_mode',
        one_shot = false,
      }
    },
  }

  config.keys = config.keys or {}
  for _, key in ipairs(tab_keys) do
    table.insert(config.keys, key)
  end

  -- NOW define what happens INSIDE tab mode
  config.key_tables = config.key_tables or {}
  config.key_tables.tab_mode = {
    -- Create a new Tab
    { key = 'c', action = act.ShowTabNavigator },  -- ← NO mods here!
    --{ key = 'l', action = act.ShowTabNavigator },  -- ← NO mods here!
    -- Show tab navigator and exit tab mode after selection
    { 
      key = 'l', 
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.ShowTabNavigator, pane)
        window:perform_action(act.PopKeyTable, pane)
      end)
    },       -- Rename current tab
    { 
      key = 'r', 
      action = act.PromptInputLine {
        description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
    
    -- Exit tab mode
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'q', action = 'PopKeyTable' },
  }
end

return M
