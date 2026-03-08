vim.g.mapleader = " "


require("catppuccin").setup({
    --flavour = "latte",
    --flavour = "frappe",
    flavour = "macchiato",
    --flavour = "mocha",
    transparent_background = true,
})


vim.cmd.colorscheme("catppuccin")

require("mini.pick").setup({ 
  source = { tool = "rg", },
  window = { preview = true, }, 
})
require("mini.extra").setup()
require("mini.notify").setup()
require("mini.files").setup()
vim.keymap.set("n", "<leader>e",   function() MiniFiles.open()               end,  { desc = "File explorer" })
vim.keymap.set("n", "<leader>ff",  function() MiniPick.builtin.files()       end,  { desc = "Find files" })
vim.keymap.set("n", "<leader>fb",  function() MiniPick.builtin.buffers()     end,  { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fg",  function() MiniPick.builtin.grep_live()   end,  { desc = "Live grep" })
vim.keymap.set("n", "<leader>fd",  function() MiniExtra.pickers.diagnostic() end,  { desc = "Diagnostics" })

local function float_term()
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })
    vim.fn.termopen(os.getenv("SHELL"))
    vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>t", function() float_term() end, { desc = "Float terminal" })
vim.keymap.set("t", "<leader>t", "<cmd>close<cr>", { desc = "Close terminal" })
vim.keymap.set("n", "<leader>so", "<cmd>source $MYVIMRC<cr>", { desc = "Source config" })


local scratch_file = vim.fn.stdpath("data") .. "/scratch.md"
local scratch_buf = nil
local function scratch()
    -- close if already open
    if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == scratch_buf then
                vim.api.nvim_win_close(win, true)
                return
            end
        end
    end

    scratch_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(scratch_buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        style = "minimal",
        border = "rounded",
    })
    vim.bo[scratch_buf].buftype = ""
    vim.bo[scratch_buf].swapfile = false
    vim.api.nvim_buf_set_name(scratch_buf, scratch_file)
    if vim.fn.filereadable(scratch_file) == 1 then
        vim.cmd("edit " .. scratch_file)
    end
end

vim.keymap.set("n", "<leader>S", scratch, { desc = "Scratch buffer" })

local function scratch()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        style = "minimal",
        border = "rounded",
    })
    vim.bo[buf].buftype = ""
    vim.bo[buf].bufhidden = "hide"
    vim.bo[buf].swapfile = false
    vim.api.nvim_buf_set_name(buf, scratch_file)
    if vim.fn.filereadable(scratch_file) == 1 then
        vim.cmd("edit " .. scratch_file)
    end
end

require("mini.completion").setup()

vim.keymap.set("n", "<leader>S", scratch, { desc = "Scratch buffer" })


vim.keymap.set("n", "<leader>so", "<cmd>source $MYVIMRC<cr>", { desc = "Source config" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
