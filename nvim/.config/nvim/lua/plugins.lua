-- .config/nvim/lua/plugins.lua

local pack_path = vim.fn.stdpath("data") .. "/site/pack"

return {
    { repo = "catppuccin/nvim",       path = pack_path .. "/themes/start/catppuccin" },
    { repo = "echasnovski/mini.nvim", path = pack_path .. "/plugins/start/mini.nvim" },
}
