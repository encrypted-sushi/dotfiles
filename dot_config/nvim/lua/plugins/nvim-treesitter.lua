-- ~/.config/nvim/lua/plugins/nvim-treesitter.lua
-- ============================================
-- NVIM-TREESITTER - SYNTAX HIGHLIGHTING
-- Centralized parsers for container architecture
-- ============================================

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  
  config = function()
    -- ============================================
    -- COMPILER CONFIGURATION SETUP
    -- ============================================
    -- Treesitter parsers are C libraries that need to be compiled.
    -- The 'install' module controls how parsers are compiled and where they're stored.
    -- We configure the compiler BEFORE attempting to install any parsers.
    local install = require("nvim-treesitter.install")
    
    -- ============================================
    -- PLATFORM DETECTION
    -- ============================================
    -- We need to know what platform we're on to configure the compiler correctly.
    -- Each platform has different compilation requirements:
    --   - Windows: Needs Zig wrapper to bypass MSVC issues
    --   - WSL: Compilation host for centralized parsers
    --   - Containers: Read-only consumers of pre-compiled parsers
    
    local is_windows = vim.fn.has("win32") == 1
    local is_wsl = vim.fn.has("wsl") == 1
    
    -- Container detection: Check for Docker/Podman marker files
    -- /.dockerenv exists in Docker containers
    -- /run/.containerenv exists in Podman containers
    local is_container = vim.fn.filereadable("/.dockerenv") == 1 or 
                         vim.fn.filereadable("/run/.containerenv") == 1
    
    -- ============================================
    -- LIBC DETECTION (Linux/WSL/Containers only)
    -- ============================================
    -- On Linux systems, we need to know which C library is being used:
    --   - musl: Used by Alpine Linux (smaller, simpler)
    --   - glibc: Used by Debian, Ubuntu, most mainstream distros
    -- 
    -- This matters because compiled C libraries (.so files) are NOT compatible
    -- between musl and glibc. A parser compiled for musl won't work on glibc.
    --
    -- Why this matters:
    --   - Alpine containers need musl-compiled parsers
    --   - Debian containers need glibc-compiled parsers
    --   - We maintain separate parser directories for each
    
    local function detect_libc()
      -- Windows doesn't use libc, so return nil
      if is_windows then return nil end
      
      -- Run 'ldd --version' which shows the libc version
      -- ldd is the dynamic linker/loader info tool
      local ldd_output = vim.fn.system("ldd --version 2>&1")
      
      -- Parse the output to determine which libc we have
      if ldd_output:match("musl") then
        return "musl"  -- Alpine-based systems
      elseif ldd_output:match("GLIBC") or ldd_output:match("glibc") then
        return "glibc" -- Debian/Ubuntu-based systems
      else
        return "unknown"
      end
    end
    
    local libc = detect_libc()
    
    -- ============================================
    -- PARSER COMPILATION & STORAGE STRATEGY
    -- ============================================
    -- We have three different environments with different needs:
    --
    -- 1. WINDOWS (Work + Personal Laptops)
    --    - Needs Zig to bypass MSVC compilation issues
    --    - Stores parsers locally (not shared)
    --    - Compiles parsers on-demand
    --
    -- 2. WSL-ALPINE (Compilation Host)
    --    - Compiles parsers for ALL containers
    --    - Stores in separate directories by libc type
    --    - These directories are bind-mounted to containers
    --
    -- 3. CONTAINERS (Development Environments)
    --    - Read-only consumers of pre-compiled parsers
    --    - Bind-mount parser directories from WSL
    --    - Never compile (no write access)
    
    if is_windows then
      -- ────────────────────────────────────────
      -- WINDOWS: Zig Wrapper for MSVC Bypass
      -- ────────────────────────────────────────
      
      -- PROBLEM: Windows has MSVC (Microsoft Visual C++) as the default compiler,
      -- but Treesitter doesn't work well with MSVC. It expects GCC-style compilation.
      --
      -- SOLUTION: Use Zig as a drop-in C/C++ compiler replacement.
      -- Zig can compile C code and has excellent cross-platform support.
      --
      -- HOW IT WORKS:
      -- 1. Create .bat wrapper files (zig-cc.bat, zig-cxx.bat)
      -- 2. These wrappers call 'zig cc' and 'zig c++' with Windows-GNU target
      -- 3. Set CC and CXX environment variables to point to these wrappers
      -- 4. Treesitter uses these instead of MSVC
      
      local config_path = vim.fn.stdpath("config")  -- Usually C:\Users\<name>\.config\nvim
      
      -- Function to create a .bat wrapper file
      -- @param name: Filename (e.g., "zig-cc")
      -- @param subcommand: Zig command (e.g., "cc" or "c++")
      -- @return: Full path to the created .bat file
      local function create_wrapper(name, subcommand)
        local path = config_path .. "\\" .. name .. ".bat"
        local f = io.open(path, "w")
        if f then
          -- The wrapper file contains a single command:
          -- "zig cc %* -target x86_64-windows-gnu"
          --   %* = pass through all arguments
          --   -target = tell Zig to compile for Windows with GNU-compatible ABI
          f:write("@echo off\nzig " .. subcommand .. " %* -target x86_64-windows-gnu")
          f:close()
        end
        return path
      end
      
      -- Create the wrapper files
      -- These are "self-healing" - regenerated each time Neovim starts
      local cc_path = create_wrapper("zig-cc", "cc")     -- C compiler
      local cxx_path = create_wrapper("zig-cxx", "c++")  -- C++ compiler
      
      -- Tell the system to use our wrappers
      vim.env.CC = cc_path   -- C compiler environment variable
      vim.env.CXX = cxx_path -- C++ compiler environment variable
      
      -- THE SILVER BULLET: Tell Treesitter we're NOT using MSVC
      -- This prevents Treesitter from trying to use MSVC-specific flags
      -- We need to wrap this in pcall because the parsers module might not exist yet
      local parsers_ok, parsers = pcall(require, "nvim-treesitter.parsers")
      if parsers_ok then
        parsers.is_msvc = function() return false end
      end
      
      -- Tell Treesitter install module which compilers to use
      install.compilers = { cc_path, cxx_path }
      
      -- Parser storage location is NOT set here - uses default:
      -- %LOCALAPPDATA%\nvim-data\lazy\nvim-treesitter\parser\
      -- (Usually: C:\Users\<name>\AppData\Local\nvim-data\...)
      
      vim.notify("Treesitter: Windows (local parsers)", vim.log.levels.INFO)
      
    elseif is_container then
      -- ────────────────────────────────────────
      -- CONTAINERS: Read-Only Parser Consumers
      -- ────────────────────────────────────────
      
      -- ARCHITECTURE:
      -- Containers are long-running development environments (Go, Rust, Python, etc.)
      -- They have:
      --   - Their own non-root user with their own $HOME
      --   - Bind-mounted Neovim binary from WSL (read-only)
      --   - Bind-mounted parsers from WSL (read-only)
      --   - NO Zig compiler (not needed - parsers pre-compiled)
      --
      -- BENEFIT: Containers start instantly (no compilation delay)
      
      -- Expected bind mount structure:
      -- /opt/nvim-parsers/
      --   ├── musl/   ← Alpine containers mount this
      --   └── glibc/  ← Debian containers mount this
      local parser_base = "/opt/nvim-parsers"
      local parser_dir = parser_base .. "/" .. (libc or "unknown")
      
      -- Sanity check: Is the bind mount present?
      if vim.fn.isdirectory(parser_dir) == 0 then
        -- The bind mount is missing - provide helpful error
        vim.notify(
          "Treesitter: Parser directory not found: " .. parser_dir .. "\n" ..
          "Expected bind mount: -v /path/to/wsl/parsers/" .. libc .. ":" .. parser_dir .. ":ro",
          vim.log.levels.ERROR
        )
        return -- Abort configuration - can't proceed without parsers
      end
      
      -- Tell Treesitter where to find parsers
      -- This overrides the default ~/.local/share/nvim location
      install.parser_install_dir = parser_dir
      
      -- Prevent Treesitter from trying to download/compile
      -- Parsers are read-only bind mounts - we can't write to them
      install.prefer_git = false
      
      vim.notify(
        "Treesitter: Container (bind-mounted parsers: " .. libc .. ")",
        vim.log.levels.INFO
      )
      
    elseif is_wsl then
      -- ────────────────────────────────────────
      -- WSL-ALPINE: Centralized Compilation Host
      -- ────────────────────────────────────────
      
      -- ROLE: WSL is the "source of truth" for all parsers
      -- When you run :TSInstall or :TSUpdate here, it compiles parsers
      -- that are then immediately available to ALL containers via bind mounts.
      --
      -- DIRECTORY STRUCTURE:
      -- ~/.local/share/nvim-parsers/
      --   ├── musl/    ← Alpine containers read from here
      --   │   ├── lua.so
      --   │   ├── go.so
      --   │   └── rust.so
      --   └── glibc/   ← Debian containers read from here
      --       ├── lua.so
      --       └── python.so
      --
      -- WHY SEPARATE DIRECTORIES:
      -- musl and glibc are INCOMPATIBLE. A .so file compiled for one
      -- will crash or fail to load on the other. We MUST maintain separate
      -- compiled parsers for each libc variant.
      
      local parser_base = vim.fn.expand("$HOME/.local/share/nvim-parsers")
      
      -- Create directory structure if it doesn't exist
      -- 'p' flag = create parent directories as needed
      vim.fn.mkdir(parser_base .. "/musl", "p")
      vim.fn.mkdir(parser_base .. "/glibc", "p")
      
      -- Determine which directory to use based on WSL's libc
      -- (WSL-Alpine uses musl, so parsers go in musl/)
      local parser_dir = parser_base .. "/" .. (libc or "unknown")
      
      -- Configure Zig to compile with explicit target
      -- This ensures we compile for the correct libc variant
      local zig_target = libc == "musl" and "x86_64-linux-musl" or "x86_64-linux-gnu"
      
      -- Set compiler to Zig with explicit target
      -- Note: On Linux, we can pass compiler args directly via env vars
      -- (Unlike Windows where we need .bat wrappers)
      vim.env.CC = "zig cc -target " .. zig_target
      vim.env.CXX = "zig c++ -target " .. zig_target
      install.compilers = { "zig" }
      
      -- CRITICAL: Tell Treesitter to install parsers to our centralized location
      -- Without this, parsers would install to default ~/.local/share/nvim
      install.parser_install_dir = parser_dir
      
      vim.notify(
        "Treesitter: WSL-Alpine (centralizing parsers: " .. libc .. ")",
        vim.log.levels.INFO
      )
      
    else
      -- ────────────────────────────────────────
      -- FALLBACK: Unknown Environment
      -- ────────────────────────────────────────
      -- This shouldn't happen, but if we're on an unexpected platform
      -- (maybe macOS in the future?), fall back to standard Treesitter behavior
      vim.notify("Treesitter: Unknown environment (standard behavior)", vim.log.levels.WARN)
    end
    
    -- ============================================
    -- LANGUAGE CONFIGURATION
    -- ============================================
    -- Determine which language parsers should be installed.
    --
    -- BASE LANGUAGES: Required everywhere for Neovim itself
    --   - lua: Neovim config files
    --   - vim: Vim script
    --   - vimdoc: Vim documentation
    --   - query: Treesitter query files
    --   - markdown: Documentation, notes
    --   - markdown_inline: Inline markdown (in code comments, etc.)
    --
    -- EXTRA LANGUAGES: Defined per-machine in local_config.lua
    --   Example for Go container:
    --     return { treesitter = { languages = { "go", "gomod", "gosum" } } }
    --   Example for Windows work laptop:
    --     return { treesitter = { languages = { "sql", "powershell", "c_sharp" } } }
    
    local base_languages = {
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
    }
    
    -- Load machine-specific languages from local_config.lua if present
    -- If local_config.lua doesn't exist or doesn't define languages, extra_languages = {}
    local extra_languages = (_G.MyConfigs.treesitter or {}).languages or {}
    
    -- Merge base + extra languages
    -- vim.list_extend modifies the first list, so we deepcopy to avoid mutation
    local all_languages = vim.list_extend(vim.deepcopy(base_languages), extra_languages)
    
    -- ============================================
    -- PARSER INSTALLATION
    -- ============================================
    -- Tell the install module which languages we want
    install.ensure_installed = all_languages
    
    -- Auto-install: Should Treesitter automatically compile parsers when you
    -- open a file type that doesn't have a parser yet?
    --
    -- CONTAINERS: NO (parsers are read-only bind mounts)
    -- WINDOWS/WSL: YES (we can compile on-demand)
    install.auto_install = not is_container
    
    -- Explicitly install all languages in our list
    -- This happens during Neovim startup, so parsers are ready immediately
    --
    -- We use pcall (protected call) to handle failures gracefully:
    --   - If a parser fails to compile, we log a warning but continue
    --   - This prevents one broken parser from breaking the entire config
    for _, lang in ipairs(all_languages) do
      local ok, err = pcall(function()
        vim.cmd("TSInstall " .. lang)
      end)
      if not ok then
        vim.notify("Treesitter: Failed to install " .. lang .. ": " .. tostring(err), vim.log.levels.WARN)
      end
    end
    
    -- ============================================
    -- SYNTAX HIGHLIGHTING ACTIVATION
    -- ============================================
    -- Modern nvim-treesitter doesn't use the old 'configs' module anymore.
    -- Instead, we use vim.treesitter.start() to enable highlighting.
    --
    -- We create an autocommand that runs whenever a file is opened (FileType event).
    -- This autocommand:
    --   1. Checks if the file is too large (>100KB)
    --   2. If not, enables Treesitter highlighting
    --
    -- WHY THE SIZE CHECK:
    -- Large files can make Treesitter slow. For files >100KB, we skip
    -- Treesitter and fall back to Vim's regex-based syntax highlighting.
    
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",  -- Apply to all file types
      callback = function()
        -- Get the current buffer's file path
        local bufname = vim.api.nvim_buf_get_name(0)
        
        -- Check file size
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, bufname)
        
        -- If file is too large, skip Treesitter
        if ok and stats and stats.size > max_filesize then
          return
        end
        
        -- Enable Treesitter highlighting for this buffer
        -- pcall = if this fails (no parser available), don't error
        pcall(vim.treesitter.start)
      end,
    })
  end,
}

-- ============================================
-- ARCHITECTURE SUMMARY
-- ============================================

--[[
CROSS-PLATFORM COMPILATION & STORAGE STRATEGY:

┌─────────────────────────────────────────────────────────────┐
│ WINDOWS (Work + Personal Laptops)                          │
│ ├── Role: Standalone development environment               │
│ ├── Compiler: Zig (via .bat wrappers)                      │
│ ├── Target: x86_64-windows-gnu                             │
│ ├── Parser Storage: %LOCALAPPDATA%\nvim-data\...           │
│ └── Behavior: Compiles parsers on-demand (auto_install)    │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ WSL-ALPINE (Compilation Host)                              │
│ ├── Role: Central parser compilation & storage             │
│ ├── Compiler: Zig (static binary)                          │
│ ├── Target: x86_64-linux-musl (Alpine uses musl)          │
│ ├── Parser Storage: ~/.local/share/nvim-parsers/           │
│ │   ├── musl/   ← Compiled with -target x86_64-linux-musl │
│ │   └── glibc/  ← Compiled with -target x86_64-linux-gnu  │
│ └── Behavior: Run :TSUpdate here to update ALL containers  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ CONTAINERS (Go, Rust, Python Development Environments)     │
│ ├── Role: Read-only parser consumers                       │
│ ├── Compiler: NONE (no Zig needed)                         │
│ ├── Parser Storage: /opt/nvim-parsers/{musl,glibc}/        │
│ │   (bind-mounted from WSL, read-only)                     │
│ ├── Behavior: No compilation, just load pre-compiled       │
│ └── Bind Mount Example:                                     │
│     podman run -it \                                        │
│       -v ~/.local/share/nvim-parsers/musl:/opt/nvim-parsers/musl:ro \
│       alpine-golang                                         │
└─────────────────────────────────────────────────────────────┘

WHY THIS ARCHITECTURE:

1. COMPILE ONCE, USE EVERYWHERE (Containers)
   - Parsers compiled in WSL are immediately available to all containers
   - No per-container compilation (faster startup)
   - No Zig needed in containers (smaller images)

2. LIBC SEPARATION (musl vs glibc)
   - musl and glibc are incompatible at the binary level
   - We maintain separate parser directories for each
   - Zig explicitly targets the correct libc variant

3. SELF-CONTAINED WINDOWS
   - Windows can't share parsers with Linux (different binary format)
   - Compiles its own parsers locally using Zig
   - Completely independent from WSL/container setup

4. CENTRALIZED UPDATES
   - Run :TSUpdate in WSL → updates all container parsers instantly
   - No need to update parsers in each container individually

5. DEVELOPMENT WORKFLOW
   - Windows: Use for cross-platform work, compile on-demand
   - WSL: Use as parser compilation host, update centrally
   - Containers: Use for language-specific development, consume pre-compiled parsers

LANGUAGE MANAGEMENT:

Per-environment language lists (via local_config.lua):

  # Windows Work Laptop
  return {
    treesitter = {
      languages = { "sql", "powershell", "c_sharp" }
    }
  }

  # WSL-Alpine (compile for containers)
  return {
    treesitter = {
      languages = { "go", "rust", "python", "toml" }
    }
  }

  # Go Container
  return {
    treesitter = {
      languages = { "go", "gomod", "gosum", "gowork" }
    }
  }

  # Rust Container
  return {
    treesitter = {
      languages = { "rust", "toml" }
    }
  }

  # Python Container
  return {
    treesitter = {
      languages = { "python", "requirements", "toml" }
    }
  }

TROUBLESHOOTING:

Windows:
  1. Ensure Zig is installed: winget install zig.zig
  2. Verify Zig in PATH: zig version
  3. Check wrappers exist: ls ~/.config/nvim/zig-*.bat
  4. Manual install: :TSInstall <language>

WSL-Alpine:
  1. Verify Zig installed: zig version
  2. Check libc: ldd --version (should show "musl")
  3. Verify directories: ls ~/.local/share/nvim-parsers/
  4. Manual compile: :TSInstall <language>
  5. Check target: zig cc --version

Containers:
  1. Verify bind mount: ls /opt/nvim-parsers/musl  (or glibc)
  2. Check libc: ldd --version
  3. Verify parsers: ls /opt/nvim-parsers/musl/*.so
  4. If parser missing: Install in WSL, then restart container

PERFORMANCE:

- Large file handling: Files >100KB skip Treesitter (use Vim regex instead)
- Auto-install: Only on Windows/WSL (containers can't compile)
- Compilation speed: Zig is fast (~2-5 seconds per parser)
- Memory: Each parser ~1-2MB compiled

FUTURE EXTENSIBILITY:

Want to add macOS support?
  1. Add macOS detection (vim.fn.has("mac"))
  2. macOS uses glibc-like system, so similar to glibc path
  3. May need to adjust Zig target to x86_64-macos or aarch64-macos

Want to add more container types?
  1. Determine libc (musl or glibc)
  2. Bind mount appropriate parser directory
  3. Add language list to container's local_config.lua
  4. Done - no code changes needed

Want to compile for different architectures (ARM)?
  1. Adjust Zig target: aarch64-linux-musl or aarch64-linux-gnu
  2. Create separate parser directory (e.g., parsers-musl-arm/)
  3. Bind mount to ARM containers
]]
