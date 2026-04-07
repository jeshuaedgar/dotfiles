return {
	-- Which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>n", group = "notifications" },
				{ "<leader>o", group = "open" },
				{ "<leader>q", group = "quit/session" },
				{ "<leader>r", group = "run/request" },
				{ "<leader>s", group = "search" },
				{ "<leader>t", group = "test" },
				{ "<leader>u", group = "ui/toggle" },
				{ "<leader>x", group = "diagnostics" },
			},
		},
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			options = {
				theme = "auto",
				globalstatus = true,
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {
					-- Diagnostics count
					{
						function()
							local s = vim.diagnostic.count(0)
							local parts = {}
							if (s[1] or 0) > 0 then
								table.insert(parts, " " .. s[1])
							end
							if (s[2] or 0) > 0 then
								table.insert(parts, " " .. s[2])
							end
							if (s[3] or 0) > 0 then
								table.insert(parts, " " .. s[3])
							end
							if (s[4] or 0) > 0 then
								table.insert(parts, "󰌶 " .. s[4])
							end
							return table.concat(parts, " ")
						end,
						cond = function()
							return #vim.diagnostic.get(0) > 0
						end,
					},
					-- LSP status (0.12: vim.lsp.status())
					{
						function()
							local status = vim.lsp.status()
							if status and status ~= "" then
								return status
							end
							return ""
						end,
					},
					-- Active LSP clients
					{
						function()
							local clients = vim.lsp.get_clients({ bufnr = 0 })
							if #clients == 0 then
								return ""
							end
							local names = {}
							for _, c in ipairs(clients) do
								table.insert(names, c.name)
							end
							return " " .. table.concat(names, ", ")
						end,
						cond = function()
							return #vim.lsp.get_clients({ bufnr = 0 }) > 0
						end,
					},
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},

	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				offsets = {
					{ filetype = "oil", text = "Explorer", highlight = "Directory", padding = 1 },
				},
			},
		},
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = { char = "│" },
			scope = { enabled = true, show_start = false, show_end = false },
			exclude = { filetypes = { "help", "lazy", "checkhealth", "oil" } },
		},
	},
}
