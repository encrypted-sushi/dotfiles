-- ftplugin/zig.lua
vim.bo.syntax = "off"
vim.treesitter.start()


-- Spacing/Tabs for idiomatic Zig
vim.opt_local.tabstop     = 4
vim.opt_local.shiftwidth  = 4
vim.opt_local.expandtab   = true

-- LSP — starts zls, or reuses it if already running for this project
vim.lsp.config['zls'] = {
  cmd          = { 'zls' },
  filetypes    = { 'zig' },
  root_markers = { 'build.zig', 'build.zig.zon', '.git' },
}
vim.lsp.enable('zls')

-- Buffer-local keymaps — { buffer = 0 } means ONLY active in this zig buffer
-- These make no sense in a yaml file, a shell file, etc. — so we don't set them globally
-- vim.keymap.set("n", "gd",         vim.lsp.buf.definition,  { buffer = 0, desc = "Go to definition" })
-- vim.keymap.set("n", "gr",         vim.lsp.buf.references,  { buffer = 0, desc = "Find references" })
-- LSP Features
vim.keymap.set("n", "K",     vim.lsp.buf.hover,          { buffer = 0, desc = "Hover docs" })
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = 0, desc = "Signature help" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,      { buffer = 0, desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0, desc = "Code action" })
vim.keymap.set("n", "gd", function() MiniExtra.pickers.lsp({ scope = "definition" })      end, { buffer = 0, desc = "Go to definition" })
vim.keymap.set("n", "gr", function() MiniExtra.pickers.lsp({ scope = "references" })      end, { buffer = 0, desc = "Go to references" })
vim.keymap.set("n", "gD", function() MiniExtra.pickers.lsp({ scope = "declaration" })     end, { buffer = 0, desc = "Go to declaration" })
vim.keymap.set("n", "gi", function() MiniExtra.pickers.lsp({ scope = "implementation" })  end, { buffer = 0, desc = "Go to implementation" })
vim.keymap.set("n", "gt", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, { buffer = 0, desc = "Go to type definition" })
vim.keymap.set("n", "<leader>fs", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, { buffer = 0, desc = "File symbols" })
vim.keymap.set("n", "<leader>fS", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol", query = query }) end, { buffer = 0, desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>fl", function()
    require("mini.pick").builtin.grep_live(nil, { 
      source = {
        name = "Zig Standard Library",
        cwd = "/opt/sbin/bundles/zig/0.16.0/lib/",
      }
    })
end, { desc = "Search Zig Standard Library" })

-- Format on save — BufWritePre fires just before the file is written to disk
-- { buffer = 0 } means this autocmd only fires for THIS buffer, not all zig files forever
-- zls delegates formatting to `zig fmt` automatically
vim.api.nvim_create_autocmd("BufWritePre", {
    buffer   = 0,
    callback = function() vim.lsp.buf.format({ async = false }) end,
    desc     = "Format on save",
})

