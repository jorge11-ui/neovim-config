return {
  -- Icons: single provider shared by neo-tree and lualine.
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = "",
        section_separators = "",
        icons_enabled = true,
        disabled_filetypes = { statusline = { "alpha" } },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(mode)
              return mode:sub(1, 1)
            end,
          },
        },
        lualine_b = {
          { "branch", icon = "" },
        },
        lualine_c = {
          {
            "filename",
            path = 1, -- relative to cwd
            symbols = { modified = "●", readonly = "", unnamed = "[No Name]" },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
          },
          "filetype",
        },
        lualine_y = {
          { "location", padding = { left = 1, right = 1 } },
        },
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "neo-tree", "fzf" },
    },
  },
}
