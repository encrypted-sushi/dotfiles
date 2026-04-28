-- lua/mini.lua

--{{{ 1. Modules
-- {{{ 1.1 Status Line       (mini.statusline)
--   README => https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-statusline.md
--   Docs   => https://github.com/nvim-mini/mini.nvim/blob/main/doc/mini-statusline.txt
require("mini.statusline").setup({
  use_icons = true,
  set_vim_settings = true,
})

-- }}}
-- {{{ 1.2 Icons             (mini.icons)
--   README => https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-icons.md
--   Docs   => https://github.com/nvim-mini/mini.nvim/blob/main/doc/mini-icons.txt
require("mini.icons").setup()

-- }}}
-- {{{ 1.3 Buffer Remover    (mini.bufremove)
require("mini.bufremove").setup()

-- }}}
-- {{{ 1.4 Picker            (mini.pick)
--   README => https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-pick.md
--   Docs   => https://github.com/nvim-mini/mini.nvim/blob/main/doc/mini-pick.txt
require("mini.pick").setup({
  source = { tool = "rg" },
  window = {
    config = function()
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.5)
      return {
        relative = "editor",
        width = width,
        height = height,
        row = (math.floor((vim.o.lines - height) / 2)) + height,
        col = math.floor((vim.o.columns - width) / 2),
      }
    end,
  },
})

-- }}}
-- {{{ 1.5 Extras            (mini.extra)
--   README => https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-extra.md
--   Docs   => https://github.com/nvim-mini/mini.nvim/blob/main/doc/mini-extra.txt
require("mini.extra").setup()

-- }}}
-- {{{ 1.6 Notify            (mini.notify)
--   README => https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-notify.md
--   Docs   => https://github.com/nvim-mini/mini.nvim/blob/main/doc/mini-notify.txt
require("mini.notify").setup()

-- }}}
-- {{{ 1.7 File Explorer    (mini.files)
--    README => https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-files.md
--    Docs   => https://github.com/nvim-mini/mini.nvim/blob/main/doc/mini-files.txt
require("mini.files").setup()

-- }}}
-- {{{ 1.8 Autocomplete      (mini.completion)
--   README => https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-completion.md
--   Docs   => https://github.com/nvim-mini/mini.nvim/blob/main/doc/mini-completion.txt
require("mini.completion").setup()
-- }}}

--}}}
--{{{ 2. Keymaps
vim.keymap.set("n", "<leader>bd", function() MiniBufremove.delete()         end, { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bw", function() MiniBufremove.wipeout()        end, { desc = "Wipeout buffer" })
vim.keymap.set("n", "<leader>ff", function() MiniPick.builtin.files()       end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fb", function() MiniPick.builtin.buffers()     end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fg", function() MiniPick.builtin.grep_live()   end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fd", function() MiniExtra.pickers.diagnostic() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>e",  function() MiniFiles.open()               end, { desc = "File explorer" })

--}}}


-- vim: set foldmethod=marker:
