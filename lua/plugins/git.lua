return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      signcolumn = false,
      numhl = false,
      linehl = false,
      word_diff = false,
      current_line_blame = false,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buffer, desc = desc })
        end

        map("[h", function()
          gs.nav_hunk("prev")
        end, "Previous hunk")
        map("]h", function()
          gs.nav_hunk("next")
        end, "Next hunk")
        map("<leader>hs", gs.stage_hunk, "Stage hunk")
        map("<leader>hr", gs.reset_hunk, "Reset hunk")
        map("<leader>hp", gs.preview_hunk, "Preview hunk")
        map("<leader>hb", function()
          gs.blame_line({ full = false })
        end, "Blame line")
      end,
    },
  },
}
