-- Manual formatting on <leader>f. No format-on-save: predictable and safe.
-- Only runs when the formatter binary for the filetype exists.

return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo", "Format" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ bufnr = 0, async = true, lsp_format = "fallback", timeout_ms = 5000 })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
      },
      log_level = vim.log.levels.WARN,
      notify_on_error = true,
      notify_no_formatters = false,
    },
    config = function(_, opts)
      require("conform").setup(opts)

      vim.api.nvim_create_user_command("Format", function(args)
        local range
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, #end_line },
          }
        end
        require("conform").format({ bufnr = 0, range = range, lsp_format = "fallback", async = false })
      end, { range = true, desc = "Format buffer or range" })
    end,
  },
}
