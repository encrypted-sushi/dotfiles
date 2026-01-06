return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = _G.MyConfigs.background_transparency or false,
    })
    vim.cmd([[colorscheme catppuccin]])
  end,
}
