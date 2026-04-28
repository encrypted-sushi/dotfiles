-- lua/keymaps.lua

--{{{ 1. Reload Config
vim.keymap.set("n", "<leader>so", "<cmd>source $MYVIMRC<cr>", { desc = "Source config" })

--}}}
--{{{ 2. Yank-related
-- This is the most important in my workflow.... yank to system clipboard!
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })

--}}}


-- vim: set foldmethod=marker:
