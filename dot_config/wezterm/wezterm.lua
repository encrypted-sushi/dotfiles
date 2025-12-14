-- ~/.wezterm.lua

local wezterm = require 'wezterm'
local config = {}

-- Load all configuration modules
require('configs.appearance').setup(config, wezterm)
require('configs.fonts').setup(config, wezterm)
require('configs.general').setup(config, wezterm)
require('configs.keymaps').setup(config, wezterm)

return config
