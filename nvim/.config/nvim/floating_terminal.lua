local term_buf = nil
local term_win = nil

local function float_term_open()
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    term_win = vim.api.nvim_open_win(term_buf, true, {
        relative = "editor",
        width = width, height = height, row = row, col = col,
        style = "minimal", border = "rounded",
    })
    vim.cmd("startinsert")
end

local function float_term()
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        if term_win and vim.api.nvim_win_is_valid(term_win) then
            vim.api.nvim_win_close(term_win, false)
            term_win = nil
        else
            float_term_open()
        end
    else
        term_buf = vim.api.nvim_create_buf(false, true)
        float_term_open()
        vim.fn.termopen(os.getenv("SHELL") or "/bin/sh")
        vim.api.nvim_create_autocmd("TermClose", {
            buffer = term_buf,
            callback = function()
                term_buf = nil
                term_win = nil
            end,
        })
    end
end

vim.keymap.set("n", "<leader>t", float_term, { desc = "Toggle float terminal" })
vim.keymap.set("t", "<leader>t", function()
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_close(term_win, false)
        term_win = nil
    end
end, { desc = "Hide float terminal", nowait = true })

