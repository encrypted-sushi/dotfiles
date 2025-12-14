vim.g.mapleader = " "
vim.g.maplocalleader = " "


local map = vim.keymap.set
-- [[ Netrw ]]
map( "n", "<leader>fe", ":Ex<CR>", { desc = "Open Netrx" } )

-- [[ Better "Esc" for me]]
map( "n", "<leader>/", ":nohlsearch<CR>" )
map( {"i", "v"}, "jk", "<Esc>", { desc = "Exit Insert/Visual mode" } )

-- [[ Yanks, because I am trying to learn to use registers ]]
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = 'Paste before cursor from clipboard' })

