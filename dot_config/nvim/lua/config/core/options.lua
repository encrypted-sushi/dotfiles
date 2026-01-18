-- lua/config/core/options.lua
local platform = require("config.platform_detection.platform")
local o = vim.opt

-- ============================================
-- PLATFORM-SPECIFIC CONFIGURATION
-- ============================================

if platform.is_windows then
  -- [[ Windows and the infamous(?) ShaDa ]]
  -- Fix ShaDa "All tmp files exist" error on Windows
  o.shada = "!,'100,<50,s10,h"

  -- This is the "Nuclear" fix if the error persists:
  -- It moves the ShaDa file OUT of the AppData/Local folder
  -- and into a place Windows/OneDrive won't harass it.
  -- o.shadafile = "C:\\temp\\main.shada" -- Only use if the line above fails

  -- The "Plumbing" for Windows: cmd.exe
  o.shell = "cmd.exe"
  o.shellcmdflag = "/K set shellslash=1 & cmd.exe /c"
  o.shellredir = ">%s 2>&1"
  o.shellpipe = "2>&1 | %s"
  o.shellquote = ""
  o.shellxquote = ""

elseif platform.is_wsl then
  -- The "Plumbing" for WSL: sh
  o.shell = "/bin/sh"

  -- Fix for OSC52 clipboard paste hangs in WSL
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }

else
  -- The "Plumbing" for Linux/Containers: sh
  o.shell = "/bin/sh"
end

-- ============================================
-- FILE FORMATS
-- ============================================

o.fileformats = "unix,dos"

-- ============================================
-- LINE NUMBERS
-- ============================================

o.number = true
o.relativenumber = true

-- ============================================
-- TAB/INDENT
-- ============================================

o.expandtab = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.smartindent = true
o.autoindent = true

-- ============================================
-- SEARCH
-- ============================================

o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

-- ============================================
-- UI
-- ============================================

o.termguicolors = true
o.signcolumn = "yes"  -- We need to use native, as Snacks statuscolumn doesn't work, according to Claude Sonnet 4.5
-- Also part of sign/status column + line number configurations
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})
o.cursorline = true
o.scrolloff = 8
o.sidescrolloff = 8

-- ============================================
-- FILE HANDLING
-- ============================================

local undodir = vim.fn.stdpath("data") .. "/undo"
vim.fn.mkdir(undodir, "p")
o.undodir = undodir
o.undofile = true
o.swapfile = false
o.backup = false
o.fsync = false

-- ============================================
-- COMPLETION
-- ============================================

o.completeopt = "menu,menuone,noselect"

-- ============================================
-- MOUSE
-- ============================================

o.mouse = "a"
