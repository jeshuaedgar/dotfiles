return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSUpdate" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter").install({
				"bash",
				"c",
				"css",
				"diff",
				"dockerfile",
				"go",
				"gomod",
				"gosum",
				"html",
				"javascript",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"powershell",
				"python",
				"query",
				"regex",
				"rust",
				"sql",
				"svelte",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
				"gotmpl",
			})

			-- Disable treesitter highlight for powershell
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "powershell",
				callback = function(ev)
					vim.treesitter.stop(ev.buf)
				end,
			})

			-- Incremental selection: 0.12 builtin
			-- v then an = select outward (expand to parent node)
			-- v then in = select inward (shrink to child node)
			-- v then ]n = next sibling
			-- v then [n = previous sibling
			--
			-- Remap to your CR/BS preference:
			vim.keymap.set("n", "<CR>", "van", { remap = true, desc = "Select node" })
			vim.keymap.set("x", "<CR>", "an", { remap = true, desc = "Expand selection" })
			vim.keymap.set("x", "<BS>", "in", { remap = true, desc = "Shrink selection" })

			-- Textobjects
			require("nvim-treesitter-textobjects").setup({
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
				},
				swap = {
					enable = true,
					swap_next = { ["<leader>cs"] = "@parameter.inner" },
					swap_previous = { ["<leader>cS"] = "@parameter.inner" },
				},
			})
		end,
	},

	-- Sticky context (function/class headers)
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			max_lines = 3,
			multiline_threshold = 1,
		},
		keys = {
			{ "<leader>ut", "<cmd>TSContextToggle<cr>", desc = "Toggle treesitter context" },
		},
	},
}
