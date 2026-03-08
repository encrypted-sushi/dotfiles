-- ftplugin/sh.lua
vim.treesitter.language.register("bash", "sh")
vim.bo.syntax = "off"
vim.treesitter.start()

vim.lsp.start({
    name = "efm",
    --cmd = { "efm-langserver" },
    cmd = { "efm-langserver", "-logfile", "/tmp/efm.log", "-loglevel", "5" },
    filetypes = { "sh" },
    root_dir = vim.fn.getcwd(),
    init_options = {
        documentFormatting = false,
        hover = false,
        documentSymbol = false,
        codeAction = false,
        completion = false,
    },
})
