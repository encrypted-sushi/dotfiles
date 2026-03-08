-- lua/config/core/treesitter.lua
--
-- Wasm treesitter parser loader for the static neovim bundle.
--
-- Two things need to happen for treesitter highlighting to work:
--
--   1. REGISTRATION (eager, at module load time):
--      vim.treesitter.language.add() must be called before any ftplugin runs.
--      Neovim 0.12 nightly's ftplugin/*.lua files call vim.treesitter.start()
--      unconditionally and crash if the parser isn't already registered.
--      We register all parsers here, synchronously, before require('config.lazy').
--
--   2. ACTIVATION (per-buffer, via FileType autocmd):
--      vim.treesitter.start() attaches the highlighter to a specific buffer.
--      This must be called for each buffer after its filetype is detected.
--      Registration alone is not enough — neovim won't auto-activate the
--      highlighter for wasm parsers the way it does for compiled-in parsers.
--
-- NVIM_PARSERS_DIR is set by the nvim wrapper script in the bundle root.
-- If it is not set (e.g. running bin/nvim directly), this file is a no-op.

local parsers_dir = vim.env.NVIM_PARSERS_DIR
if not parsers_dir then
  vim.notify(
    'treesitter: NVIM_PARSERS_DIR not set — wasm parsers will not be loaded.\n'
    .. 'Use the nvim wrapper script in the bundle root, not bin/nvim directly.',
    vim.log.levels.WARN
  )
  return
end

-- ---------------------------------------------------------------------------
-- Step 1: Eager registration of all wasm parsers
--
-- Called once at module load time. After this, every parser below is known
-- to neovim's language registry and ftplugins can safely call start() on them.
-- ---------------------------------------------------------------------------
local wasm_parsers = {
  bash            = 'tree-sitter-bash.wasm',
  lua             = 'tree-sitter-lua.wasm',
  markdown        = 'tree-sitter-markdown.wasm',
  markdown_inline = 'tree-sitter-markdown_inline.wasm',
}

for lang, filename in pairs(wasm_parsers) do
  local wasm = parsers_dir .. '/' .. filename
  if vim.fn.filereadable(wasm) == 1 then
    local ok, err = pcall(vim.treesitter.language.add, lang, { path = wasm })
    if not ok then
      vim.notify('treesitter: failed to register ' .. lang .. ': ' .. tostring(err),
        vim.log.levels.WARN)
    end
  else
    vim.notify('treesitter: wasm file not found: ' .. wasm, vim.log.levels.WARN)
  end
end

-- ---------------------------------------------------------------------------
-- Language aliases
--
-- The 'sh' filetype uses the 'bash' parser. Register this so neovim's query
-- resolution finds the right .scm files for sh buffers.
-- ---------------------------------------------------------------------------
vim.treesitter.language.register('bash', 'sh')

-- Map filetypes whose name differs from the parser name.
local ft_to_parser = {
  sh = 'bash',
}

-- ---------------------------------------------------------------------------
-- Step 2: Per-buffer highlighter activation
--
-- Attaches vim.treesitter.start() to each buffer when its filetype is set.
-- Registration (step 1) must have already run — this just activates the
-- highlighter for the specific buffer.
--
-- Note: lua, markdown etc. are included here even though their ftplugins
-- also call start() — the pcall makes it safe to call twice (idempotent).
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'bash', 'lua', 'markdown' },
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    local lang = ft_to_parser[ft] or ft
    local ok, err = pcall(vim.treesitter.start, ev.buf, lang)
    if not ok then
      vim.notify('treesitter: ' .. lang .. ': ' .. tostring(err), vim.log.levels.WARN)
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Shebang detection for extensionless files
--
-- Neovim detects filetypes by extension. Extensionless scripts (e.g. files
-- in /usr/local/bin/) get no filetype without this. Setting the filetype
-- here will trigger the FileType autocmd above for highlighting.
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  callback = function(ev)
    if vim.bo[ev.buf].filetype ~= '' then return end
    local first_line = vim.api.nvim_buf_get_lines(ev.buf, 0, 1, false)[1] or ''
    if first_line:match('^#!/.*/sh') or first_line:match('^#!/.*/bash') then
      vim.bo[ev.buf].filetype = 'sh'
    elseif first_line:match('^#!/.*/python') then
      vim.bo[ev.buf].filetype = 'python'
    elseif first_line:match('^#!/.*/node') then
      vim.bo[ev.buf].filetype = 'javascript'
    end
  end,
})
