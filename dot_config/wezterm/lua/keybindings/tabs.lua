-- lua/keybindings/tabs.lua
local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

-- ==========================================================
-- Tab Mode Action Functions
-- ==========================================================
local function enter_tab_mode()
  return act.ActivateKeyTable {
    name = 'tab_mode',
    one_shot = false,
  }
end


-- Create New Tab:  map to "c"
local function create_tab()
  return act.SpawnTab('CurrentPaneDomain')
end


-- List Tabs: map to "l"
local function list_tabs()
  return wezterm.action_callback(function(window, pane)
    -- Exit tab mode first to avoid key conflicts
    window:perform_action(act.PopKeyTable, pane)
    -- Display the tab selector
    window:perform_action(act.ShowTabNavigator, pane)
  end)
end


-- Rename Tab: map to "r"
local function rename_tab()
  return wezterm.action_callback(function(window, pane)
    -- Exit tab mode first to avoid key conflicts
    window:perform_action(act.PopKeyTable, pane)
    -- Now prompt for a new name
    window:perform_action(
      -- action
      act.PromptInputLine {
        description = "New name for tab",
        action = wezterm.action_callback(function(win, p, line)
          if line then
            win:active_tab():set_title(line)
          end
        end),
      },

      -- pane
      pane
    )
  end)
end



-- ==========================================================
-- Tab Mode Keymaps
-- ==========================================================
function M.setup(config)
  config.keys = config.keys or {}
  config.key_tables = config.key_tables or {}
  
  -- Add keybinding to ENTER tab mode
  table.insert(config.keys, {
    key = 't', mods = 'LEADER', action = enter_tab_mode()
  })

  -- Tab mode key mappings
  config.key_tables.tab_mode = {
    { key = 'c', action = create_tab() },
    { key = 'l', action = list_tabs() },
    { key = 'r', action = rename_tab() },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'q', action = 'PopKeyTable' },
    { key = 'c', mods = 'CTRL', action = 'PopKeyTable' },
  }
end

return M
