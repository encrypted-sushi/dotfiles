-- .config/nvim/lua/plugins.lua

local pack_path = vim.fn.stdpath("data") .. "/site/pack"

return {
    { repo = "catppuccin/nvim",       path = pack_path .. "/themes/start/catppuccin" },
    { repo = "rebelot/kanagawa.nvim", path = pack_path .. "/themes/start/kanagawa" },
    { repo = "echasnovski/mini.nvim", path = pack_path .. "/plugins/start/mini.nvim" },
}
