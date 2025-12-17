-- 1. SHELL DETECTION LOGIC
-- Helper to find the first existing executable in a list
local function find_best_shell(shells)
  for _, shell in ipairs(shells) do
    if vim.fn.executable(shell) == 1 then
      return shell
    end
  end
  return nil
end

local is_windows = vim.fn.has("win32") == 1
local win_shells = { "pwsh.exe", "powershell.exe", "cmd.exe" }
local nix_shells = { "/opt/fish/fish", "/usr/bin/fish", "/bin/bash", "/bin/sh" }

-- The "POSIX-style" ternary logic in Lua
local interactive_shell = is_windows and find_best_shell(win_shells) or find_best_shell(nix_shells)

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- "Better file explorer than netrw"
    explorer = { 
        enabled = true,
        replace_netrw = true, 
    },
    -- "Better terminal"
    terminal = { 
      shell = interactive_shell,
      win = {
        style = "float",
        width = 0.9,  -- 90% of screen width
        height = 0.8, -- 80% of screen height
        border = "rounded", -- Gives it those nice curved corners
      },
    },
    -- "Smooth scrolling"
    scroll = { enabled = true },
    -- "Beautiful notifications"
    notifier = { enabled = true },
    -- "Modern-looking pop-ups"
    input = { enabled = true },
    statuscolumn = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        files = { 
          hidden = true, -- Shows .config, .gitignore, etc.
          ignored = false, -- Shows things in .gitignore (optional, set to false if you want to skip git-ignored files)
        }
      },
      -- This makes Snacks act like FZF (Search with ' for exact, ^ for start, etc.)
      matcher = { fuzzy = true, fzf = true }, 
      -- YOUR BURRLIST: Tell Snacks never to look at these
      exclude = {
        ".git",
        "node_modules",
        "NTUSER.DAT*",
        "ntuser.dat*",
        "AppData",
        "OneDrive/Old_Cruft_Folder/*", -- Add your specific OneDrive junk here
      },
      -- Modern layouts (optional, but 'telescope' style is comfy)
      layout = { preset = "telescope" }, 
    },
  },
  keys = {
    -- 📂 The New Explorer
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      
    -- 💻 The Floating Terminal
    { "<leader>t", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle Terminal" },
      
    -- 📋 The "Vim Way" Register Picker
    { "<leader>sr", function() Snacks.picker.registers() end, desc = "Search Registers" },
      
    -- 🔍 Other Pickers
    { "<leader>sf", function() Snacks.picker.files() end, desc = "Snacks Find Files" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Snacks Live Grep" },
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Snacks Buffers" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Snacks Help" },
  },
}
