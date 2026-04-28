-- lua/scratch_buffer.lua

--{{{ 1. Scratch Buffer (by Claude)
local scratch_file = vim.fn.stdpath("data") .. "/scratch.md"
local scratch_buf = nil

local function scratch()
  -- If open in a window, close it (toggle off)
  if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == scratch_buf then
        vim.api.nvim_win_close(win, true)
        return
      end
    end
    -- Buffer exists but is hidden — reuse it, just open a new window
  else
    scratch_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[scratch_buf].buftype = ""
    vim.bo[scratch_buf].bufhidden = "hide"
    vim.bo[scratch_buf].swapfile = false
    vim.api.nvim_buf_set_name(scratch_buf, scratch_file)
  end

  vim.api.nvim_open_win(scratch_buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.1),
    style = "minimal",
    border = "rounded",
  })
  if vim.fn.filereadable(scratch_file) == 1 then
    vim.cmd("edit " .. scratch_file)
  end
end

--}}}
--{{{ 2. Keymaps
vim.keymap.set("n", "<leader>S", scratch, { desc = "Scratch buffer" })

--}}}


-- vim: set foldmethod=marker:
