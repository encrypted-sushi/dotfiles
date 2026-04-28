-- lua/options
local o = vim.opt

--{{{ 1. UI
-- {{{ 1.1 Line Number
o.number = true
o.relativenumber = true
-- }}}
-- {{{ 1.2 Cursor
o.cursorline = true
-- }}}
-- {{{ 1.3 Scrolling
o.scrolloff = 8
o.sidescrolloff = 8
-- }}}

--}}}
--{{{ 2. Tab / Indent
o.expandtab = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.smartindent = true
o.autoindent = true

--}}}
--{{{ 3. Files (undo, etc.)
local undodir = vim.fn.stdpath("data") .. "/undo"
vim.fn.mkdir(undodir, "p")
o.undodir = undodir
o.undofile = true
o.swapfile = false
o.backup = false
o.fsync = false

--}}}
--{{{ 4. Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

--}}}
--{{{ 5. Diagnostic
vim.diagnostic.config({ virtual_text = true, signs = true, underline = true, })

--}}}


-- vim: set foldmethod=marker:
