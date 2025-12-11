-- Custom plugin that makes it easy to log some coode...

return {
  {
    "console-log",
    dir = vim.fn.stdpath("config"),
    event = "VeryLazy",
    config = function()
      local function console_log()
        local mode = vim.fn.mode()
        local text

        if mode == "v" or mode == "V" then
          -- Visual mode: get selected text
          vim.cmd('noau normal! "vy')
          text = vim.fn.getreg("v")
        else
          -- Normal mode: get word under cursor
          text = vim.fn.expand("<cword>")
        end

        -- Get current cursor position
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))

        -- Insert console.log below current line
        local log_statement = string.format("console.log('%s:', %s);", text, text)
        vim.api.nvim_buf_set_lines(0, row, row, false, { log_statement })

        -- Move cursor to the new line
        vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
      end

      -- Create autocmd for JS/TS files
      vim.api.nvim_create_augroup("JSLogMacro", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = "JSLogMacro",
        pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        callback = function()
          vim.keymap.set({ "n", "v" }, "<leader>cp", console_log, {
            buffer = true,
            desc = "Console log word/selection",
          })
        end,
      })
    end,
  },
}
