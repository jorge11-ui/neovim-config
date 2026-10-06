-- Start screen: alpha-nvim, minimal centered layout.

return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    lazy = false,
    priority = 900,
    config = function()
      require("mini.pairs").setup()
      require("mini.surround").setup({
        mappings = {
          add = "sa",
          delete = "sd",
          find = "sf",
          find_left = "sF",
          highlight = "sh",
          replace = "sr",
          update_n_lines = "sn",
        },
      })
      require("mini.ai").setup()
      require("mini.move").setup({
        mappings = {
          left = "<A-h>",
          right = "<A-l>",
          down = "<A-j>",
          up = "<A-k>",
          line_left = "<A-h>",
          line_right = "<A-l>",
          line_down = "<A-j>",
          line_up = "<A-k>",
        },
      })
    end,
  },

  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return require("alpha.themes.dashboard")
    end,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  "",
  [[    _  _______ ____ _   _______  ___ ]],
  [[   / |/ / __/ __ \ | / /  _/  |/  / ]],
  [[  /    / _// /_/ / |/ // // /|_/ /  ]],
  [[ /_/|_/___/\____/|___/___/_/  /_/   ]],
  "",
}

dashboard.section.buttons.val = {
  dashboard.button("f", "󰈞  Find File",     ":Telescope find_files<CR>"),
  dashboard.button("r", "󰋚  Recent Files",   ":Telescope oldfiles<CR>"),
  dashboard.button("g", "󰊄  Find Text",      ":Telescope live_grep<CR>"),
  dashboard.button("c", "󰒓  Configuration",  ":e $MYVIMRC<CR>"),
  dashboard.button("p", "󰏗  Plugins",        ":Lazy<CR>"),
  dashboard.button("q", "󰈆  Quit",           ":confirm q<CR>"),
}

      alpha.setup(dashboard.opts)
    end,
  },
}
