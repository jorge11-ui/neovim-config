-- LSP: diagnostics, navigation, rename, actions.
-- Completion via blink.cmp.

return {
  -- Simple word suggestions only
  {
    "saghen/blink.cmp",
    opts = {
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        sources = { "cmdline", "path", "buffer" },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function()
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = true },
        },
      },
      sources = {
        default = { "buffer" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
          },
        },
        float = { source = "if_many", header = "", prefix = "" },
      })

      vim.lsp.config("lua_ls", {
        root_dir = vim.fs.root(0, { ".luarc.json", ".luacheckrc", ".stylua.toml", ".git" }) or vim.fn.getcwd(),
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false, library = {} },
            hint = { enable = false },
          },
        },
      })

      local lspconfig = require("lspconfig")

      lspconfig.basedpyright.setup({
        autostart = false,
      })

      lspconfig.ruff.setup({
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
          client.server_capabilities.definitionProvider = false
        end,
      })



      local servers = {
        clangd = { "c", "cpp" },
        lua_ls = { "lua" },
        cssls = { "css" },
      }
      for name in pairs(servers) do
        if vim.fn.executable(name == "lua_ls" and "lua-language-server" or name) == 1 then
          vim.lsp.enable(name)
        end
      end

      local mapbuf = function(lhs, rhs, desc, buffer)
        vim.keymap.set("n", lhs, rhs, { buffer = buffer, silent = true, desc = desc })
      end

      local lsp_enabled = true
      vim.keymap.set("n", "<leader>lt", function()
        if lsp_enabled then
          vim.cmd("LspStop")
          vim.notify("LSP desativado", vim.log.levels.INFO)
        else
          vim.cmd("LspStart")
          vim.notify("LSP ativado", vim.log.levels.INFO)
        end
        lsp_enabled = not lsp_enabled
      end, { desc = "Toggle LSP" })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          if client:supports_method("textDocument/definition") then
            mapbuf("gd", vim.lsp.buf.definition, "Go to definition", args.buf)
            mapbuf("gD", vim.lsp.buf.declaration, "Go to declaration", args.buf)
          end
          if client:supports_method("textDocument/references") then
            mapbuf("gr", function()
              require("telescope.builtin").lsp_references()
            end, "References", args.buf)
          end
          if client:supports_method("textDocument/implementation") then
            mapbuf("gI", function()
              require("telescope.builtin").lsp_implementations()
            end, "Implementations", args.buf)
          end
          if client:supports_method("textDocument/hover") then
            mapbuf("K", vim.lsp.buf.hover, "Hover documentation", args.buf)
          end
          if client:supports_method("textDocument/codeAction") then
            mapbuf("<leader>ca", vim.lsp.buf.code_action, "Code actions", args.buf)
          end
          if client:supports_method("textDocument/rename") then
            mapbuf("<leader>rn", vim.lsp.buf.rename, "Rename symbol", args.buf)
          end
          if client:supports_method("textDocument/documentSymbol") then
            mapbuf("<leader>ls", function()
              require("telescope.builtin").lsp_document_symbols()
            end, "Document symbols", args.buf)
          end
        end,
      })
    end,
  },
}
