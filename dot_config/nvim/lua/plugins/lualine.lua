return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    theme = "catppuccin",
    globalstatus = true, -- This makes the bar solid and singular
    refresh = {
      statusline = 1000, -- Only update once per second
    }
  },
}
