return {
	"zaldih/themery.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("themery").setup({
			themes = {
				"bamboo",
				"aether",
				"ethereal",
				"hackerman",
				"vantablack",
				"white",
				"catppuccin",
				"catppuccin-mocha",
				"catppuccin-latte",
				"everforest",
				"flexoki",
				"gruvbox",
				"kanagawa",
				"kanagawa-dragon",
				"kanagawa-wave",
				"matteblack",
				"monokai-pro",
				"nightfox",
				"nordfox",
				"terafox",
				"dayfox",
				"rose-pine",
				"rose-pine-main",
				"rose-pine-dawn",
				"ashen",
				"tokyonight",
				"tokyonight-night",
				"tokyonight-storm",
				"tokyonight-day",
				"miasma",
				"retro-82",
				"lumon",
			},
			telescope = {
				enabled = true,
			},
		})

		vim.keymap.set("n", "<leader>t", "<cmd>Themery<cr>", { desc = "Change colorscheme" })
	end,
}
