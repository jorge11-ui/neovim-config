return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>mm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
    { "<leader>ma", function() require("harpoon.mark").add_file() end, desc = "Add to Harpoon" },
    { "<A-1>", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon file 1" },
    { "<A-2>", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon file 2" },
    { "<A-3>", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon file 3" },
    { "<A-4>", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon file 4" },
  },
}
