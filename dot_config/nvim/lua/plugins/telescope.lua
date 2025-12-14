return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "NTUSER%.DAT",
          "ntuser%.dat",
          "NTUSER%.DAT%.*",
          "%.git/",
          "node_modules/",
          "%.local/share/chezmoi/",
          "%.local\\share\\chezmoi\\",
        },
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
      },
    })

    -- Keybindings
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>fa", function()
      builtin.find_files({ hidden = true, no_ignore = true })
    end, { desc = "Find all files" })
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
  end,
}
