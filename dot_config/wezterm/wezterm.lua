-- wezterm.lua

local wezterm = require('wezterm')
local utils = require('configs.preload.utils')
local config = wezterm.config_builder()

-- Configure the LEADER first
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

utils.load_directory(config, 'configs/appearances')
utils.load_directory(config, 'configs/keybindings')
utils.load_directory(config, 'configs/behaviors')
-- -- Load all configuration modules
-- require('lua.appearances').setup(config)
-- require('lua.general').setup(config)
-- require('lua.keybindings').setup(config)

return config
