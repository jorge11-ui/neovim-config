vim.g.lazyvim_check_order = false
require("config.lazy")

-- Python plugin: HelloPython command
vim.cmd([[command! HelloPython py3 vim.current.buffer[0] = "Olá do Python!"]])

-- Rodar arquivo Python com <leader>r
vim.keymap.set("n", "<leader>r", ":!python %<CR>", { desc = "Run Python file" })
