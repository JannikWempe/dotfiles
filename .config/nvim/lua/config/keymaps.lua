-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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
