local o = vim.opt
local is_windows = vim.fn.has("win32") == 1


if is_windows then
  -- [[ Windows and the infamous(?) ShaDa ]]
  -- Fix ShaDa "All tmp files exist" error on Windows
  vim.opt.shada = "!,'100,<50,s10,h"

  -- This is the "Nuclear" fix if the error persists:
  -- It moves the ShaDa file OUT of the AppData/Local folder 
  -- and into a place Windows/OneDrive won't harass it.
  -- vim.opt.shadafile = "C:\\temp\\main.shada" -- Only use if the line above fails

  -- The "Plumbing" for Windows: cmd.exe
  vim.o.shell = "cmd.exe"
  vim.o.shellcmdflag = "/K set shellslash=1 & cmd.exe /c"
  vim.o.shellredir = ">%s 2>&1"
  vim.o.shellpipe = "2>&1 | %s"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
else
  -- The "Plumbing" for Linux/WSL: sh
  vim.o.shell = "/bin/sh"
end

-- [[ Line numbers ]]
o.number = true
o.relativenumber = true

-- [[ Tab/Indent ]]
o.expandtab = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.smartindent = true
o.autoindent = true

-- [[ Search ]]
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- [[ UI ]]
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- [[ File handling ]]
local undodir = vim.fn.stdpath("data") .. "/undo"
vim.fn.mkdir(undodir, "p")
vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.fsync = false

-- Completion
vim.opt.completeopt = "menu,menuone,noselect"

-- Mouse
vim.opt.mouse = "a"


