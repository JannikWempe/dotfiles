vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Do not yank deleting a single character
vim.keymap.set("n", "x", '"_x', {
    noremap = false
})

-- Increment/Decrement
vim.keymap.set("n", "+", "<C-a>", {
    noremap = false
})
vim.keymap.set("n", "-", "<C-x>", {
    noremap = false
})

-- Buffer
vim.keymap.set("n", "[b", "<cmd>bp<CR>", {
    desc = "[B]uffer [P]revious"
})
vim.keymap.set("n", "]b", "<cmd>bn<CR>", {
    desc = "[B]uffer [N]ext"
})
vim.keymap.set("n", "[B", "<cmd>bfirst<CR>", {
    desc = "[B]uffer [F]irst"
})
vim.keymap.set("n", "]B", "<cmd>blast<CR>", {
    desc = "[B]uffer [L]ast"
})
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", {
    desc = "[B]uffer [D]elete"
})

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
-- keep cursor in middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- keep searc term in middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {
    desc = "[Y]ank to system clipboard"
})
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- quick fix list navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
    desc = "[S]ubstitude word under cursor"
})
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", {
    desc = "Make File E[x]ecutable",
    silent = true
})
