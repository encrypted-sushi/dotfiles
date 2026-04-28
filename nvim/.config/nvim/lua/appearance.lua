-- lua/appearance.lua

--{{{ 1. Theme
require("kanagawa").setup({
  theme = "wave",
  transparent = true,
})
vim.cmd.colorscheme("kanagawa-wave")

--}}}
--{{{ 2. Workarounds
-- {{{ 2.1 UI elements
-- Force stubborn UI elements to be transparent
local transparent_groups = {
  "Normal",
  "NormalNC",
  "SignColumn",
  "FoldColumn",
  "Folded",
  "LineNr",
  "CursorLineNr",
  "EndOfBuffer",
  "StatusLine",
  "StatusLineNC",
  "VertSplit",
  "WinSeparator",
}
for _, group in ipairs(transparent_groups) do
  vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
end

-- }}}
-- {{{ 2.2 Complemetions menu
-- Semi-transparent completion menu
vim.api.nvim_set_hl(0, "Pmenu",       { bg = "#1a1a28", fg = "#dcd7ba" })
vim.api.nvim_set_hl(0, "PmenuSel",    { bg = "#2d4f67", fg = "#c8c093" }) -- selected item
vim.api.nvim_set_hl(0, "PmenuSbar",   { bg = "#1a1a28" })                 -- scrollbar track
vim.api.nvim_set_hl(0, "PmenuThumb",  { bg = "#7e9cd8" })                 -- scrollbar thumb
vim.api.nvim_set_hl(0, "PmenuBorder", { bg = "#1a1a28", fg = "#7e9cd8" }) -- border
-- }}}
--}}}

 
-- vim: set foldmethod=marker:
