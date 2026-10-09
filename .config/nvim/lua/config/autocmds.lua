-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Insert `console.log('<expr>:', <expr>);` below the cursor for the word or selection.
local function console_log()
  local mode = vim.fn.mode()
  local text
  if mode == "v" or mode == "V" then
    text = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode }), "\n")
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  else
    text = vim.fn.expand("<cword>")
  end

  local row = vim.api.nvim_win_get_cursor(0)[1]
  local indent = vim.fn.getline(row):match("^%s*")
  vim.api.nvim_buf_set_lines(0, row, row, false, { indent .. string.format("console.log('%s:', %s);", text, text) })
  vim.api.nvim_win_set_cursor(0, { row + 1, #indent })
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("console_log", { clear = true }),
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function(event)
    vim.keymap.set({ "n", "x" }, "<leader>cp", console_log, { buffer = event.buf, desc = "Console log word/selection" })
  end,
})
