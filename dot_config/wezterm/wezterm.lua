-- ~/.wezterm.lua

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Configure the LEADER first
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Load all configuration modules
require('lua.appearances').setup(config)
require('lua.general').setup(config)
require('lua.keybindings').setup(config)

return config
