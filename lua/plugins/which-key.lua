return {

    {

        "folke/which-key.nvim",

        event = "VeryLazy",

        opts = {

            delay = 400,

            preset = false,

            icons = { rules = false },

            win = { border = "none", nohl = true },

            spec = {

                { "<leader>f",  group = "Find / Format" },

                { "<leader>ff", desc = "Find files" },

                { "<leader>fg", desc = "Grep project" },

                { "<leader>fb", desc = "Buffers" },

                { "<leader>fr", desc = "Recent files" },

                { "<leader>fh", desc = "Help" },

                { "<leader>fs", desc = "Search in buffer" },

                { "<leader>d",  desc = "Diagnostics" },

                { "<leader>n",  desc = "New file" },

                { "<leader>c",  desc = "Open config" },

                { "<leader>ca", desc = "Code actions" },

                { "<leader>p",  desc = "Plugin manager" },

                { "<leader>g",  group = "Git" },

                { "<leader>gg", desc = "LazyGit" },

                { "<leader>h",  group = "Hunk (git)" },

                { "<leader>hs", desc = "Stage hunk" },

                { "<leader>hr", desc = "Reset hunk" },

                { "<leader>hp", desc = "Preview hunk" },

                { "<leader>hb", desc = "Blame line" },

                { "<leader>rn", desc = "Rename symbol" },

                { "<leader>l",  group = "LSP" },

                { "<leader>ls", desc = "Document symbols" },

            },

        },

    },

}
