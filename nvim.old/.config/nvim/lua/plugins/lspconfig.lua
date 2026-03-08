return {
  'neovim/nvim-lspconfig',
  config = function()
    -- ZLS for Zig files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "zig",
      callback = function()
        vim.lsp.start({
          name = "zls",
          cmd = { "zls" },
          root_dir = vim.fn.getcwd(),
        })
      end,
    })

    -- LSP keybindings — buffer-local, only active when LSP is running
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>gl", vim.diagnostic.open_float, opts)
      end,
    })
  end,
}
