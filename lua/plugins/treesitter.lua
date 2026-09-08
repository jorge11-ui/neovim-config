-- Treesitter: parsers + highlighting + folding.
-- Neovim 0.12 handles folding via 'foldexpr' set in options.lua.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      -- Parsers for toolchains actually present on the system.
      local wanted = { "bash", "json", "lua", "markdown", "markdown_inline", "query", "vim", "vimdoc", "yaml" }
      local extras = {
        node = { "javascript", "typescript", "tsx", "html", "css" },
        python3 = { "python" },
        gcc = { "c" },
      }
      for bin, langs in pairs(extras) do
        if vim.fn.executable(bin) == 1 then
          vim.list_extend(wanted, langs)
        end
      end

      local installed = {} ---@type table<string, boolean>
      for _, lang in ipairs(require("nvim-treesitter.config").get_installed()) do
        installed[lang] = true
      end

      local missing = vim.tbl_filter(function(lang)
        return not installed[lang]
      end, wanted)

      if #missing > 0 then
        require("nvim-treesitter.install").install(missing, {})
      end

      -- Start highlighting wherever a parser exists (core ftplugins cover lua/help).
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          local path = vim.api.nvim_buf_get_name(args.buf)
          local stat = path ~= "" and vim.uv.fs_stat(path)
          if stat and stat.size > 512 * 1024 then
            return -- keep huge files fast
          end
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
