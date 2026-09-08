return {
	{
		name = "theme-hotreload",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 1000,
		config = function()
			local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"
			local colorscheme_name = "rose-pine"
			local theme_plugin_name = "rose-pine"

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyReload",
				callback = function()
					vim.schedule(function()
						-- Clear all highlight groups before applying the theme
						vim.cmd("highlight clear")
						if vim.fn.exists("syntax_on") then
							vim.cmd("syntax reset")
						end

						-- Reset background to default so the (dark) colorscheme can set it properly
						vim.o.background = "dark"

						-- Unload the rose-pine plugin modules so its setup() runs fresh with
						-- the desired opts on reload.
						local plugin = require("lazy.core.config").plugins[theme_plugin_name]
						if plugin then
							require("lazy.core.util").walkmods(plugin.dir .. "/lua", function(modname)
								package.loaded[modname] = nil
								package.preload[modname] = nil
							end)
						end

						-- Re-run setup()/apply the colorscheme
						require("lazy.core.loader").colorscheme(colorscheme_name)
						vim.defer_fn(function()
							pcall(vim.cmd.colorscheme, colorscheme_name)

							-- Force redraw to update all UI elements
							vim.cmd("redraw!")

							-- Reload transparency settings
							if vim.fn.filereadable(transparency_file) == 1 then
								vim.defer_fn(function()
									vim.cmd.source(transparency_file)

									-- Trigger UI updates for various plugins
									vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
									vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })

									-- Final redraw
									vim.cmd("redraw!")
								end, 5)
							end
						end, 5)
					end)
				end,
			})
		end,
	},
}
