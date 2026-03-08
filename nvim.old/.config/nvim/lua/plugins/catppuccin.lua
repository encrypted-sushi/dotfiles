return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      integrations = {        -- needs to be in here
        treesitter = true,
      },
    })
    vim.cmd([[colorscheme catppuccin]])
  end,
}
