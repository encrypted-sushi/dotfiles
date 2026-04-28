-- init.lua
vim.g.mapleader = " "        -- <== must stay here, before any require()

require("plugins")
require("options")
require("appearance")
require("mini")
require("floating_terminal")
require("keymaps")           -- <== As a convention, require this last
