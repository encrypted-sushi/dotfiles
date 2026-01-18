return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
      }),
    })
    
    -- -- Override Ctrl+N/P in Snacks picker buffers
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = "snacks_picker_input",
    --   callback = function(ev)
    --     -- Unmap nvim-cmp's Ctrl+N/P in this buffer
    --     vim.keymap.del('i', '<C-n>', { buffer = ev.buf })
    --     vim.keymap.del('i', '<C-p>', { buffer = ev.buf })
    --   end,
    -- })
  end,
}
