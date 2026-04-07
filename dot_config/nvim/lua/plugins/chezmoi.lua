return {
	-- Chezmoi file detection and highlighting
	{
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			vim.g["chezmoi#use_tmp_buffer"] = true
			vim.g["chezmoi#source_dir_path"] = vim.fn.expand("~/.local/share/chezmoi")
		end,
	},

	-- Chezmoi edit integration
	{
		"xvzc/chezmoi.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>oc",
				function()
					require("fzf-lua").files({
						cwd = vim.fn.expand("~/.local/share/chezmoi"),
						prompt = "Chezmoi> ",
					})
				end,
				desc = "Open chezmoi file",
			},
		},
		opts = {},
		init = function()
			-- Auto-apply on save for chezmoi managed files
			vim.api.nvim_create_autocmd("BufReadPre", {
				pattern = vim.fn.expand("~") .. "/.local/share/chezmoi/*",
				callback = function()
					vim.schedule(function()
						require("chezmoi.commands.__edit").watch()
					end)
				end,
			})
		end,
	},
}
