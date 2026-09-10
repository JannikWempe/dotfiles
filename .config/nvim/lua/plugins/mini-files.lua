return {
  "nvim-mini/mini.files",
  init = function()
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("mini_files_yank_path", { clear = true }),
      pattern = "MiniFilesBufferCreate",
      callback = function(event)
        local function yank_path(relative)
          local files = require("mini.files")
          local entry = files.get_fs_entry()
          if not entry then
            return
          end

          local path = entry.path
          if relative then
            local state = files.get_explorer_state()
            local win = state and state.target_window
            local buf = win and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) or nil
            local root = LazyVim.root.get({ buf = buf })
            path = vim.fs.relpath(root, path)
            if not path then
              vim.notify("Entry is outside the project root: " .. root, vim.log.levels.WARN)
              return
            end
          end

          vim.fn.setreg('"', path)
          vim.fn.setreg("+", path)
          vim.notify("Copied: " .. path)
        end

        vim.keymap.set("n", "gy", function()
          yank_path(true)
        end, { buffer = event.data.buf_id, desc = "Yank project-relative path" })
        vim.keymap.set("n", "gY", function()
          yank_path(false)
        end, { buffer = event.data.buf_id, desc = "Yank absolute path" })
      end,
    })
  end,
  opts = {
    mappings = {
      -- make arrow keys behave like hjkl
      go_in = "l",
      go_in_plus = "<Right>",
      go_out = "h",
      go_out_plus = "<Left>",
      go_up = "k",
      go_down = "j",
    },
  },
}
