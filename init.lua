vim.g.lazyvim_check_order = false
require("config.lazy")

-- Python plugin: HelloPython command
vim.cmd([[command! HelloPython py3 vim.current.buffer[0] = "Olá do Python!"]])

-- Rodar arquivo Python com <leader>r
vim.keymap.set("n", "<leader>r", ":!python3 %<CR>", { desc = "Executar ficheiro Python", silent = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Destacar texto ao copiar",
    callback = function()
        vim.highlight.on_yank({ hilightgroup = "IncSearch", timeout = 150 })
    end,
})

