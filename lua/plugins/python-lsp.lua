-- Python LSP: pylsp with jedi completions only.

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  once = true,
  callback = function()
    local root = vim.fs.root(0, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" })
      or vim.fn.getcwd()

    local client_id = vim.lsp.start({
      name = "pylsp",
      cmd = { "pylsp" },
      root_dir = root,
      single_file_support = true,
      settings = {
        pylsp = {
          plugins = {
            jedi_completion = { eager = true, include_params = false },
            jedi_hover = {},
            jedi_references = {},
            jedi_signature_help = {},
            jedi_symbols = { all_scopes = true },
            jedi_definition = {},
            rope_completion = { enabled = false },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            black = { enabled = false },
            flake8 = { enabled = false },
            pylint = { enabled = false },
            pycodestyle = { enabled = false },
            pyflakes = { enabled = false },
            mccabe = { enabled = false },
            preload = { enabled = false },
            configuration = { enabled = false },
          },
        },
      },
    })

    if client_id then
      vim.lsp.buf_attach_client(0, client_id)
    end
  end,
})

return {}
