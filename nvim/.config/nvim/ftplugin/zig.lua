-- ftplugin/zig.lua
vim.bo.syntax = "off"
vim.treesitter.start()


-- Spacing/Tabs for idiomatic Zig
vim.opt_local.tabstop     = 4
vim.opt_local.shiftwidth  = 4
vim.opt_local.expandtab   = true

-- LSP — starts zls, or reuses it if already running for this project
vim.lsp.start({
    name     = "zls",
    cmd      = { "zls" },
    root_dir = vim.fs.root(0, { "build.zig", "build.zig.zon", ".git" }),
})

-- Buffer-local keymaps — { buffer = 0 } means ONLY active in this zig buffer
-- These make no sense in a yaml file, a shell file, etc. — so we don't set them globally
vim.keymap.set("n", "gd",         vim.lsp.buf.definition,  { buffer = 0, desc = "Go to definition" })
vim.keymap.set("n", "gr",         vim.lsp.buf.references,  { buffer = 0, desc = "Find references" })
vim.keymap.set("n", "K",          vim.lsp.buf.hover,       { buffer = 0, desc = "Hover docs" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,      { buffer = 0, desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0, desc = "Code action" })

-- Format on save — BufWritePre fires just before the file is written to disk
-- { buffer = 0 } means this autocmd only fires for THIS buffer, not all zig files forever
-- zls delegates formatting to `zig fmt` automatically
vim.api.nvim_create_autocmd("BufWritePre", {
    buffer   = 0,
    callback = function() vim.lsp.buf.format({ async = false }) end,
    desc     = "Format on save",
})

