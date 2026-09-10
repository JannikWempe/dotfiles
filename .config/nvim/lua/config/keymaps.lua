-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Copy a file reference with 1-based, inclusive Unicode character columns.
local function yank_file_reference(include_content)
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.bo.buftype ~= "" then
    vim.notify("No file to reference", vim.log.levels.WARN)
    return
  end

  local root = LazyVim.root.get()
  path = vim.fs.relpath(root, path)
  if not path then
    vim.notify("File is outside the project root: " .. root, vim.log.levels.WARN)
    return
  end

  -- Read the live selection: '< and '> can still refer to a previous selection.
  local mode = vim.fn.mode()
  local reference
  if mode == "v" then
    -- Let Neovim normalize backwards and exclusive selections.
    local region = vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode, eol = true })
    if #region == 0 then
      return
    end
    local function position(pos)
      local line = vim.fn.getline(pos[2])
      -- Region endpoints may point at the final byte of a multibyte character.
      local byte = math.max(0, pos[3] - 1)
      local column = byte >= #line and (vim.fn.strchars(line) + 1) or (vim.fn.charidx(line, byte, true) + 1)
      return pos[2] .. ":" .. column
    end
    reference = path .. ":" .. position(region[1][1]) .. "-" .. position(region[#region][2])
  else
    -- Linewise (and blockwise) selections are represented by their line range.
    local anchor, cursor = vim.fn.line("v"), vim.fn.line(".")
    local first, last = math.min(anchor, cursor), math.max(anchor, cursor)
    reference = path .. ":" .. first
    if last ~= first then
      reference = reference .. "-" .. last
    end
  end

  local text = reference
  if include_content then
    -- Include complete lines for context, preserving their original indentation.
    -- Use the normalized region so exclusive selections match the reference.
    local region = vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode, eol = true })
    if #region == 0 then
      return
    end
    local first, last = region[1][1][2], region[#region][2][2]
    local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
    local content = table.concat(lines, "\n")
    -- Keep snippets containing Markdown fences inside a single code block.
    local fence_length = 3
    for backticks in content:gmatch("`+") do
      fence_length = math.max(fence_length, #backticks + 1)
    end
    local fence = string.rep("`", fence_length)
    text = reference .. "\n" .. fence .. vim.bo.filetype .. "\n" .. content .. "\n" .. fence
  end

  vim.fn.setreg('"', text)
  vim.fn.setreg("+", text)
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  vim.notify("Copied: " .. reference)
end

vim.keymap.set("x", "gy", function()
  yank_file_reference(false)
end, { desc = "Yank project-relative file reference" })
vim.keymap.set("x", "gY", function()
  yank_file_reference(true)
end, { desc = "Yank file reference with full-line context" })

-- center screen after some jumps
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true })

-- map arrow keys to hjkl because in some situation they behave differently
vim.keymap.set("n", "<Up>", "k", { noremap = true, silent = true })
vim.keymap.set("n", "<Down>", "j", { noremap = true, silent = true })
vim.keymap.set("n", "<Left>", "h", { noremap = true, silent = true })
vim.keymap.set("n", "<Right>", "l", { noremap = true, silent = true })

-- quick access to my custom git commands
vim.keymap.set("n", "<leader>gw", ":!git wip<CR>", { noremap = true, silent = true, desc = "WIP commit" })
vim.keymap.set("n", "<leader>gu", ":!git uncommit<CR>", { noremap = true, silent = true, desc = "undo last commit" })

-- window resizing (override LazyVim defaults to resize by 5 instead of 1); no one needs to resize by 1
vim.keymap.set("n", "<leader>w+", "<cmd>resize +5<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<leader>w-", "<cmd>resize -5<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>w>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
vim.keymap.set("n", "<leader>w<", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })

-- move lines
vim.keymap.set("n", "<M-Down>", "<Cmd>execute 'move .+' . v:count1<CR>==", { desc = "Move Down" })
vim.keymap.set("n", "<M-Up>", "<Cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = "Move Up" })
vim.keymap.set("i", "<M-Down>", "<esc><Cmd>m .+1<CR>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<M-Up>", "<esc><Cmd>m .-2<CR>==gi", { desc = "Move Up" })
vim.keymap.set("x", "<M-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = "Move Down" })
vim.keymap.set("x", "<M-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = "Move Up" })

-- i don't need single chars in my copy list
vim.keymap.set({ "n", "x" }, "x", '"_x', { desc = "Delete Chars Into Void" })
vim.keymap.set({ "n", "x" }, "X", '"_x', { desc = "Delete Chars Into Void" })
vim.keymap.set({ "n", "x" }, "<Del>", '"_x', { desc = "Delete Chars Into Void" })
