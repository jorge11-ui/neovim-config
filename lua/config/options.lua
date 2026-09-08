-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

require("config.remote_clipboard").setup()

local opt = vim.opt

-- Line numbers
opt.nu = true
opt.relativenumber = true

-- Indentation & Tabs (4 spaces)
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search settings
opt.hlsearch = false
opt.incsearch = true

-- Appearance & Scrolling
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

-- Undo / Swap history
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- Fast update time
opt.updatetime = 50

vim.g.autoformat = false

-- Ensure ~/.local/bin is in PATH for formatter binaries
vim.env.PATH = vim.env.HOME .. "/.local/bin:" .. (vim.env.PATH or "")

-- netrw: thin list layout, keep the banner.
vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 1

-- Force netrw to open files in the current window
vim.g.netrw_browse_split = 0

-- Keep netrw from leaving leftover empty buffers when opening files
vim.g.netrw_keepdir = 0

-- Disable command line suggestions (wildmenu)
opt.wildmenu = false
opt.wildmode = "list"


