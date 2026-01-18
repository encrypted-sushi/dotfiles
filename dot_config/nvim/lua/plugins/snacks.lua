-- ============================================
-- SNACKS.NVIM - COMPLETE CONFIGURATION
-- Optimized for Windows performance
-- Telescope replacement with native Lua speed
-- ============================================

local platform = require("config.platform_detection.platform")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- ============================================
    -- CORE FEATURES
    -- ============================================

    -- File explorer (replaces netrw)
    explorer = {
      enabled = true,
      replace_netrw = true,
      hidden = true, -- Show hidden files by default
    },

    -- Floating terminal
    terminal = {
      enabled = true,
      shell = platform.interactive_shell,
      win = {
        style = "float",
        width = 0.9,
        height = 0.8,
        border = "rounded",
      },
    },

    -- Smooth scrolling
    scroll = {
      enabled = true,
      animate = {
        duration = {
          step = 10,   -- Duration of each frame in ms.    Default: 15  (lower = smoother but more frames)
          total = 100, -- Total animation duration in ms.  Default: 250 (lower = faster)
        },
      },
    },

    -- Beautiful notifications
    notifier = {
      enabled = true,
      timeout = 3000,
    },

    -- Modern input prompts
    input = {
      enabled = true,
    },

    -- Status column (git signs, diagnostics, etc.)
    -- NOTE: Disabling for now, as it seem to be misconfigured, and line numbers aren't being displayed
    statuscolumn = {
      --enabled = true,
      enabled = false,
    },

    -- ============================================
    -- PICKER (Telescope replacement)
    -- ============================================

    picker = {
      enabled = true,

      -- Show hidden files, respect .gitignore
      sources = {
        files = {
          hidden = true,
          follow_symlinks = true,
        },

        -- THIS IS THE EXPLORER CONFIG - FLOATING WINDOW
        explorer = {
          hidden = true,
          auto_close = true,
          layout = {
            preview = false,
            layout = {
              position = "float",
              width = 0.8,
              height = 0.8,
              border = "rounded",
            },
          },
        },
      },

      -- FZF-style fuzzy matching
      matcher = {
        fuzzy = true,
        fzf = true,
      },

      -- Modern UI
      layout = {
        preset = "telescope",
      },

      -- Better file display
      formatters = {
        file = {
          filename_first = true,
        },
      },

      -- Performance: limit preview size
      previewers = {
        enabled = true,
        max_file_size = 1024 * 100, -- 100KB
      },
    },

    -- ============================================
    -- PERFORMANCE FEATURES
    -- ============================================

    -- Fast file opening (defers expensive operations)
    quickfile = {
      enabled = true,
    },

    -- Handle large files gracefully
    bigfile = {
      enabled = true,
      size = 1024 * 500, -- 500KB threshold
      setup = function()
        vim.cmd("syntax off")
        vim.opt_local.foldmethod = "manual"
        vim.opt_local.spell = false
      end,
    },

    -- ============================================
    -- EDITOR ENHANCEMENTS
    -- ============================================

    -- Highlight word under cursor
    words = {
      enabled = true,
      debounce = 100,
    },

    -- Indent guides
    indent = {
      enabled = true,
      indent = {
        enabled = true,
        char = "│",
      },
      scope = {
        enabled = true,
        char = "│",
      },
    },

    -- Scratch buffers for quick notes/testing
    scratch = {
      enabled = true,
      name = "scratch",
      ft = "markdown",
      icon = "󱞂",
      root = vim.fn.stdpath("data") .. "/scratch",
      autowrite = true,
      filekey = {
        cwd = true,
        branch = false, -- You don't use git yet
        count = true,
      },
    },

    -- Zen mode for focus
    zen = {
      enabled = true,
      -- Use default window sizing - it works great
    },

    -- Toggle common editor options easily
    toggle = {
      enabled = true,
      map = {
        color_column = {
          name = "Color Column",
          get = function() return vim.wo.colorcolumn ~= "" end,
          set = function(state)
            vim.wo.colorcolumn = state and "80" or ""
          end,
        },
        spell = {
          name = "Spelling",
          get = function() return vim.wo.spell end,
          set = function(state) vim.wo.spell = state end,
        },
        wrap = {
          name = "Line Wrap",
          get = function() return vim.wo.wrap end,
          set = function(state) vim.wo.wrap = state end,
        },
        relative_number = {
          name = "Relative Numbers",
          get = function() return vim.wo.relativenumber end,
          set = function(state) vim.wo.relativenumber = state end,
        },
        diagnostics = {
          name = "Diagnostics",
          get = function()
            return vim.diagnostic.is_enabled and vim.diagnostic.is_enabled()
          end,
          set = vim.diagnostic.enable,
        },
      },
    },
  },

  -- ============================================
  -- KEYMAPS
  -- ============================================

  keys = {
    -- ──────────────────────────────────────────
    -- CORE NAVIGATION
    -- ──────────────────────────────────────────

    -- File explorer
    { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },

    -- Terminal
    { "<leader>t", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Terminal" },
    { "<C-/>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Terminal (Quick)" },
    { "<C-_>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Terminal (Alternative)" },

    -- ──────────────────────────────────────────
    -- FINDER (TELESCOPE REPLACEMENT)
    -- ──────────────────────────────────────────

    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Find Grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Find Help" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Find Recent" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Find Word" },
    { "<leader>fc", function() Snacks.picker.commands() end, desc = "Find Commands" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Find Keymaps" },

    -- Special searches (keep <leader>s prefix for these)
    { "<leader>sr", function() Snacks.picker.registers() end, desc = "Search Registers" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Search Marks" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Search Jumps" },

    -- ──────────────────────────────────────────
    -- LSP INTEGRATION
    -- ──────────────────────────────────────────
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>cs", function() Snacks.picker.lsp_document_symbols() end, desc = "Document Symbols" },
    { "<leader>cS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace Symbols" },
    { "<leader>cd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },

    -- Word navigation (jump between references)
    { "]]", function() Snacks.words.jump(1, true) end, desc = "Next Reference" },
    { "[[", function() Snacks.words.jump(-1, true) end, desc = "Prev Reference" },

    -- ──────────────────────────────────────────
    -- PRODUCTIVITY
    -- ──────────────────────────────────────────

    -- Scratch buffer
    { "<leader>.", function() Snacks.scratch() end, desc = "Scratch Buffer" },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch" },

    -- Zen mode
    { "<leader>z", function() Snacks.zen() end, desc = "Zen Mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Zoom" },

    -- ──────────────────────────────────────────
    -- NOTIFICATIONS & BUFFER MANAGEMENT
    -- ──────────────────────────────────────────

    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
    { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification History" },

    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },

    -- ──────────────────────────────────────────
    -- TOGGLES (UI OPTIONS)
    -- ──────────────────────────────────────────
    -- LINE NUMBERS
    -- The below configuration is a convenience function, provided by snacks.nvim, to toggle both at once.
    -- If individual toggles are wanted, uncomment the two lines below.
    -- { "<leader>ul", function() Snacks.toggle.option("number", { name = "Line Numbers" }):toggle() end, desc = "Toggle Line Numbers" },
    -- { "<leader>ur", function() Snacks.toggle.option("relativenumber", { name = "Relative Numbers" }):toggle() end, desc = "Toggle Relative Numbers" },
    { "<leader>ubl", function() Snacks.toggle.line_number():toggle() end, desc = "Toggle Line Numbers" },

    -- DIAGNOSTICS
    { "<leader>ud", function() Snacks.toggle.diagnostics():toggle() end, desc = "Toggle Diagnostics" },

    -- INLAY HINTS
    { "<leader>ui", function() Snacks.toggle.inlay_hints():toggle() end, desc = "Toggle Inlay Hints" },

    -- OTHERS (Might be useful down the line)
    -- Color Column
    { "<leader>uc", function() Snacks.toggle.option("colorcolumn", { off = "", on = "80", name = "Color Column" }):toggle() end, desc = "Toggle Color Column" },

    -- Spelling
    { "<leader>us", function() Snacks.toggle.option("spell", { name = "Spelling" }):toggle() end, desc = "Toggle Spelling" },

    -- Line wrap
    { "<leader>uw", function() Snacks.toggle.option("wrap", { name = "Line Wrap" }):toggle() end, desc = "Toggle Line Wrap" },
  },
}

-- ============================================
-- CONFIGURATION NOTES
-- ============================================

--[[
FEATURES ENABLED:
✓ Explorer (file browser)
✓ Terminal (floating shell)
✓ Scroll (smooth scrolling)
✓ Notifier (notifications)
✓ Input (prompts)
✓ Statuscolumn (git signs, diagnostics)
✓ Picker (Telescope replacement - FAST on Windows!)
✓ Quickfile (performance)
✓ Bigfile (large file handling)
✓ Words (highlight references)
✓ Indent (indent guides)
✓ Scratch (quick notes)
✓ Zen (focus mode)
✓ Toggle (UI options)

FEATURES DISABLED (not needed for your workflow):
✗ Dashboard (you hate dashboards)
✗ LazyGit/gh/gitbrowse (not using git yet)
✗ Animate (unnecessary)
✗ Dim (can be distracting)
✗ Scope (advanced, maybe later)
✗ Profiler/Debug (only for debugging Neovim)

KEYMAP PHILOSOPHY:
<leader>f* = Find (files, grep, buffers, etc.)
<leader>s* = Search (registers, marks, jumps)
<leader>c* = Code/LSP (symbols, diagnostics)
<leader>u* = UI toggles
<leader>e  = Explorer
<leader>t  = Terminal
<leader>.  = Scratch
<leader>z  = Zen

PERFORMANCE NOTES:
- Native Lua = no subprocess spawning = FAST on Windows
- .gitignore is automatically respected
- Hidden files shown by default
- Preview limited to 100KB for speed
- Big files (>500KB) have features disabled automatically

WINDOWS-SPECIFIC:
- Shell detection automatically finds best shell
- No security software slowdowns (no fork/exec)
- Substantially faster than Telescope with rg subprocess
]]
