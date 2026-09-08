-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open netrw file explorer (thin list, banner on).
vim.keymap.set("n", "<leader>pv", "<cmd>Ex<cr>", { desc = "Open netrw explorer" })
vim.keymap.set("n", "<leader>e", "<cmd>Ex<cr>", { desc = "Open netrw explorer" })
vim.keymap.set("n", "<C-b>", "<cmd>Ex<cr>", { desc = "Open netrw explorer" })

local keymap = vim.keymap.set

-- Move selected lines up/down in Visual mode (with auto-indent)
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when appending line below
keymap("n", "J", "mzJ`z")

-- Keep cursor centered when scrolling half-pages
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Keep cursor centered during search navigation
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Paste over highlighted text without losing original buffer register
keymap("x", "<leader>p", [["_dP]])

--~/.config/nvim/lua/config/ ~/.config/nvim/lua/config/S~/.config/nvim/lua/config/y~/.config/nvim/lua/config/stem clipboard integration (<leader>y to copy to system clipboard)
keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])

-- Quick delete to void register
keymap({ "n", "v" }, "<leader>d", [["_d]])

-- Disable 'Q' in normal mode
keymap("n", "Q", "<nop>")

-- Git (Fugitive)
keymap("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })

keymap("n", "<leader>gp", function()
  vim.cmd("Git push")
end, { desc = "Git push" })

keymap("n", "<leader>gP", function()
  vim.cmd("Git pull --rebase")
end, { desc = "Git pull rebase" })

keymap("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff split" })
