return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    lazy = false,
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        dark_variant = "moon",
        disable_background = true,
        disable_float_background = true,
        styles = {
          bold = true,
          italic = false,
          transparency = true,
        },
      })

       vim.cmd("colorscheme rose-pine")

       vim.cmd([[highlight CommentItalic gui=none]])
       vim.cmd([[highlight @markup.italic gui=none]])
       vim.cmd([[highlight @markup.quote gui=none]])
       vim.cmd([[highlight @markup.emphasis gui=none]])
       vim.cmd([[highlight MiniStarterFooter gui=none]])
     end,
   },
 }
