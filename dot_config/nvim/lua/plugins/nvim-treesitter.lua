-- ~/.config/nvim/lua/plugins/nvim-treesitter.lua
-- Shared parser compilation across WSL and containers

local platform = require("config.platform_detection.platform")

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",

  opts = function()
    -- Set parser directory early (before plugin loads)
    if not platform.is_windows then
      local parser_base = platform.is_container and "/opt/nvim-parsers" 
                          or vim.fn.expand("$HOME/.local/share/nvim-parsers")
      local parser_dir = parser_base .. "/" .. platform.libc

      vim.fn.mkdir(parser_dir .. "/parser", "p")
      
      -- Add parser directory to runtime path so Neovim can find parsers
      vim.opt.rtp:prepend(parser_dir)

      return { install_dir = parser_dir }
    end

    return {}
  end,

  config = function(_, opts)
    require('nvim-treesitter').setup(opts)

    local install = require("nvim-treesitter.install")

    -- Explicitly set parser_install_dir from opts
    if opts.install_dir then
      install.parser_install_dir = opts.install_dir
    end

    -- Prevent ftplugins from auto-starting treesitter before parsers are ready
    -- Set this globally to disable auto-start from built-in ftplugins
    vim.g.ts_highlight_enable = false

    if platform.is_windows then
      -- Windows: Use Zig to bypass MSVC
      local bin_dir = vim.fn.stdpath("cache") .. "\\bin"
      vim.fn.mkdir(bin_dir, "p")

      local function create_wrapper(name, subcommand)
        local path = bin_dir .. "\\" .. name .. ".bat"
        local f = io.open(path, "w")
        if f then
          f:write("@echo off\nzig " .. subcommand .. " %* -target x86_64-windows-gnu")
          f:close()
        end
        return path
      end

      local cc_path = create_wrapper("zig-cc", "cc")
      local cxx_path = create_wrapper("zig-cxx", "c++")

      vim.env.CC = cc_path
      vim.env.CXX = cxx_path

      local parsers_ok, parsers = pcall(require, "nvim-treesitter.parsers")
      if parsers_ok then
        parsers.is_msvc = function() return false end
      end

      install.compilers = { cc_path, cxx_path }
      vim.notify("Treesitter: Windows (local parsers)", vim.log.levels.INFO)

    elseif is_container then
      -- Containers: Use bind-mounted tools and shared parsers
      local parser_dir = "/opt/nvim-parsers/" .. libc

      if vim.fn.isdirectory(parser_dir) == 0 then
        vim.notify(
          "Treesitter: Missing bind mount: -v ~/.local/share/nvim-parsers/" .. platform.libc .. ":/opt/nvim-parsers/" .. platform.libc .. ":rw",
          vim.log.levels.ERROR
        )
        return
      end

      vim.env.PATH = "/opt/bin:" .. vim.env.PATH
      vim.env.GIT = "/opt/bin/git"

      local zig_target = platform.libc == "musl" and "x86_64-linux-musl" or "x86_64-linux-gnu"
      local zig_wrapper = "/tmp/zig-cc-wrapper-" .. platform.libc .. ".sh"

      local f = io.open(zig_wrapper, "w")
      if f then
        f:write("#!/bin/sh\n")
        f:write('exec /opt/bin/zig cc -target ' .. zig_target .. ' "$@"\n')
        f:close()
        vim.fn.system("chmod +x " .. vim.fn.shellescape(zig_wrapper))
      end

      vim.env.CC = zig_wrapper
      install.compilers = { zig_wrapper }
      install.auto_install = true
      install.prefer_git = true

      vim.notify("Treesitter: Container (" .. platform.libc .. ") -> " .. parser_dir, vim.log.levels.INFO)

    elseif platform.is_wsl then
      -- WSL: Use static tools from /opt/bin
      local parser_dir = vim.fn.expand("$HOME/.local/share/nvim-parsers") .. "/" .. platform.libc

      if vim.fn.isdirectory("/opt/bin") == 0 then
        vim.notify("Treesitter: /opt/bin not found", vim.log.levels.ERROR)
        return
      end

      local zig_target = (platform.libc == "musl") and "x86_64-linux-musl" or "x86_64-linux-gnu"
      local bin_dir = vim.fn.stdpath("cache") .. "/bin"
      local wrapper_path = bin_dir .. "/ts-zig-wrapper"

      vim.fn.mkdir(bin_dir, "p")

      -- Unified wrapper for 'cc' and 'tree-sitter'
      local f = io.open(wrapper_path, "w")
      if f then
        f:write("#!/bin/sh\n\n")

        -- Compiler mode: strip tree-sitter-cli's target, use ours
        -- Note: Unlike Windows, appending doesn't work reliably here
        f:write('if [ "$(basename "$0")" = "cc" ]; then\n')
        f:write('  args=$(echo "$@" | sed "s/-target [^ ]*//g")\n')
        f:write('  exec /opt/bin/zig cc -target ' .. zig_target .. ' $args\n')
        f:write("fi\n\n")

        -- Tree-sitter CLI mode: ignore verification panics from static binary
        f:write('/opt/bin/tree-sitter "$@"\n')
        f:write("exit 0\n")
        f:close()
        vim.fn.system("chmod +x " .. vim.fn.shellescape(wrapper_path))
      end

      vim.fn.system("ln -sf " .. wrapper_path .. " " .. bin_dir .. "/cc")
      vim.fn.system("ln -sf " .. wrapper_path .. " " .. bin_dir .. "/tree-sitter")

      vim.env.PATH = bin_dir .. ":/opt/bin:" .. vim.env.PATH
      vim.env.CC = bin_dir .. "/cc"
      vim.env.GIT = "/opt/bin/git"

      install.compilers = { bin_dir .. "/cc" }
      install.prefer_git = true
      install.auto_install = true

      vim.notify("Treesitter: WSL (" .. libc .. ") -> " .. parser_dir, vim.log.levels.INFO)

    else
      vim.notify("Treesitter: Unknown environment", vim.log.levels.WARN)
    end

    -- Language configuration
    local base_languages = {
      "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
    }

    local extra_languages = (_G.MyConfigs and _G.MyConfigs.treesitter or {}).languages or {}
    local all_languages = vim.list_extend(vim.deepcopy(base_languages), extra_languages)

    install.ensure_installed = all_languages

    -- Auto-install missing parsers
    local function install_missing()
      -- Skip if no custom install dir (Windows uses default)
      if not platform.is_windows and not install.parser_install_dir then
        vim.notify("Treesitter: parser_install_dir not set, skipping auto-install", vim.log.levels.WARN)
        return
      end

      local install_mod = require("nvim-treesitter.install")
      local parser_base = install.parser_install_dir or (vim.fn.stdpath('data') .. '/site')

      for _, lang in ipairs(all_languages) do
        local parser_path = parser_base .. "/parser/" .. lang .. ".so"
        if vim.fn.filereadable(parser_path) == 0 then
          vim.notify("Treesitter: Installing " .. lang, vim.log.levels.INFO)
          vim.schedule(function()
            local ok, err = pcall(function()
              install_mod.install(lang)
            end)
            if not ok then
              vim.notify("Treesitter: Failed to install " .. lang .. ": " .. tostring(err), vim.log.levels.WARN)
            end
          end)
        end
      end
    end

    vim.defer_fn(install_missing, 1000)

    -- Syntax highlighting activation
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local lang = vim.bo.filetype

        -- Skip large files (>100KB)
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, bufname)
        if ok and stats and stats.size > max_filesize then return end

        -- Only start treesitter if parser exists
        if install.parser_install_dir then
          local parser_path = install.parser_install_dir .. "/parser/" .. lang .. ".so"
          if vim.fn.filereadable(parser_path) == 1 then
            pcall(vim.treesitter.start)
          else
            vim.cmd("syntax on")
          end
        else
          pcall(vim.treesitter.start)
        end
      end,
    })
  end,
}
