-- lua/floating_terminal.lua
local term_buf = nil
local term_win = nil

--{{{ 1. Functions
-- {{{ 1.1 float_term_open()
-- Helper: Call nvim lua api to create a window for the floating terminal
local function float_term_open()
    local width  = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)
    local row    = math.floor((vim.o.lines - height) / 2)
    local col    = math.floor((vim.o.columns - width) / 2)

    term_win = vim.api.nvim_open_win(term_buf, true, {
        relative = "editor",
        width = width, height = height, row = row, col = col,
        style = "minimal", border = "rounded",
    })

    -- Keep term_win honest if the window gets closed externally (e.g. :q)
    vim.api.nvim_create_autocmd("WinClosed", {
        pattern  = tostring(term_win),
        once     = true,
        callback = function() term_win = nil end,
    })

    vim.cmd("startinsert")
end
-- }}}
-- {{{ 1.2 float_term()
-- Toggles floating terminal
local function float_term()
    -- Case 1: window is visible → hide it
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_close(term_win, false)
        term_win = nil
        return
    end

    -- Case 2: buffer exists but window is hidden → reuse buffer, open window
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        float_term_open()
        return
    end

    -- Case 3: no buffer at all → create buffer, open window, start shell (once)
    term_buf = vim.api.nvim_create_buf(false, true)
    float_term_open()
    vim.fn.termopen(os.getenv("SHELL") or "/bin/sh")

    vim.api.nvim_create_autocmd("TermClose", {
        buffer   = term_buf,
        once     = true,
        callback = function()
            term_buf = nil
            term_win = nil
        end,
    })
end
-- }}}

--}}}
--{{{ 2. Keymaps
vim.keymap.set("n", "<leader>t", float_term, { desc = "Toggle float terminal" })-- vim: set foldmethod=marker:
vim.keymap.set("t", "<leader>t", float_term, { desc = "Toggle float terminal", nowait = true })
--}}}


-- vim: set foldmethod=marker:
