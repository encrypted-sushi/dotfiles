return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local install = require("nvim-treesitter.install")
    local parsers = require("nvim-treesitter.parsers")

    -- 1. THE AUTO-WRAPPER
    -- We programmatically create the .bat file so it's "self-healing"
    --
    local config_path = vim.fn.stdpath("config")
    local function create_wrapper(name, subcommand)
      local path = config_path .. "\\" .. name .. ".bat"
      local f = io.open(path, "w")
      if f then
        f:write("@echo off\nzig " .. subcommand .. " %* -target x86_64-windows-gnu")
        f:close()
      end
      return path
    end

    local cc_path = create_wrapper("zig-cc", "cc")
    local cxx_path = create_wrapper("zig-cxx", "c++")
    --


    -- 2. THE LUA INTERFACE
    -- Now we tell the environment that our new .bat file IS the C compiler.
    -- The CLI sees a single file path, so it won't break on spaces.
    vim.env.CC = cc_path
    vim.env.CXX = cxx_path
    
    -- 3. THE SILVER BULLET
    parsers.is_msvc = function() return false end

    -- 4. THE SETTINGS
    install.compilers = { cc_path, cxx_path }

    -- 5. INSTALL & AUTO-START
    local target_langs = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }
    install.install(target_langs)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = target_langs,
      callback = function()
        -- Use pcall to start treesitter. 
        -- If the parser is missing or broken, it just won't start, 
        -- but it won't crash your editor.
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
