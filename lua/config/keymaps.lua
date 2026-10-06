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

-- System clipboard integration (<leader>y to copy to system clipboard)
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

-- =============================================
-- EDIÇÃO RÁPIDA
-- =============================================

-- Duplicate line (normal/visual)
keymap("n", "<leader>c", "yyp", { desc = "Duplicate line" })
keymap("v", "<leader>c", "y`>p", { desc = "Duplicate selection" })

-- Select all
keymap("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Undo break points (para desfazer em blocos)
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Replace word under cursor
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Indent/Deindent in visual mode (mantém seleção)
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move lines up/down in normal mode
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Move lines in visual mode
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Fast save
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Quit all
keymap("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all" })

-- Split navigation (Ctrl + seta)
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Resize splits with arrows
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Buffer navigation
keymap("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<C-Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<C-S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Alternate file (last edited file)
keymap("n", "<leader>fa", "<cmd>e #<CR>", { desc = "Alternate file" })

-- Diagnostics
keymap("n", "<leader>xn", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<leader>xp", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
keymap("n", "<leader>xf", vim.diagnostic.open_float, { desc = "Show diagnostic" })
