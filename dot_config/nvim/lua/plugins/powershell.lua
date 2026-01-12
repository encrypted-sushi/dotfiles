-- ~/.config/nvim/lua/plugins/powershell.lua
local platform = require("config.platform_detection.platform")

if platform.is_windows then
  return {
    'neovim/nvim-lspconfig',
    config = function()
       local mason_path = vim.fn.stdpath('data') .. '/mason'

--       require('lspconfig').powershell_es.setup{
--         bundle_path = mason_path .. '/packages/powershell-editor-services',
--       }
--
      -- Use the new vim.lsp.config API (no deprecation warning)
      vim.lsp.config('powershell_es', {
        cmd = vim.lsp.config.powershell_es.cmd,
        filetypes = { 'ps1', 'psm1', 'psd1' },
        root_markers = { 'PSScriptAnalyzerSettings.psd1', '.git' },
        bundle_path = mason_path .. '/packages/powershell-editor-services',
      })

      vim.lsp.enable('powershell_es')
    end,
  }
else
  return {}
end
