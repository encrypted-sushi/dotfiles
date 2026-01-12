-- ~/.config/nvim/lua/config/platform.lua
-- Centralized platform detection for all config files

local M = {}

-- ============================================
-- OPERATING SYSTEM DETECTION
-- ============================================

M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
M.is_wsl = vim.fn.has("wsl") == 1
M.is_mac = vim.fn.has("mac") == 1
M.is_linux = not M.is_windows and not M.is_wsl and not M.is_mac

-- ============================================
-- CONTAINER DETECTION
-- ============================================

M.is_container = vim.fn.filereadable("/.dockerenv") == 1 or
                 vim.fn.filereadable("/run/.containerenv") == 1

-- ============================================
-- LIBC DETECTION (for Linux/WSL)
-- ============================================

function M.detect_libc()
  if M.is_windows then return nil end
  
  local ldd_output = vim.fn.system("ldd --version 2>&1")
  if ldd_output:match("musl") then
    return "musl"
  elseif ldd_output:match("GLIBC") or ldd_output:match("glibc") then
    return "glibc"
  else
    return "unknown"
  end
end

M.libc = M.detect_libc()

-- ============================================
-- SHELL DETECTION
-- ============================================

function M.find_best_shell(shells)
  for _, shell in ipairs(shells) do
    if vim.fn.executable(shell) == 1 then
      return shell
    end
  end
  return nil
end

-- Platform-specific shell preferences
local win_shells = { "pwsh.exe", "powershell.exe", "cmd.exe" }
local nix_shells = { "/opt/fish/fish", "/usr/bin/fish", "/bin/bash", "/bin/sh" }

M.interactive_shell = M.is_windows 
  and M.find_best_shell(win_shells) 
  or M.find_best_shell(nix_shells)

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

-- Get platform-appropriate path separator
M.path_sep = M.is_windows and "\\" or "/"

-- Get platform name as string
function M.name()
  if M.is_windows then return "windows"
  elseif M.is_wsl then return "wsl"
  elseif M.is_mac then return "mac"
  elseif M.is_container then return "container"
  else return "linux" end
end

return M
