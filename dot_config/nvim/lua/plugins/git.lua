return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(buf)
				local gs = package.loaded.gitsigns
				local function bmap(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buf, desc = desc })
				end
				bmap("n", "]h", function()
					gs.nav_hunk("next")
				end, "Next hunk")
				bmap("n", "[h", function()
					gs.nav_hunk("prev")
				end, "Prev hunk")
				bmap("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
				bmap("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
				bmap("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage hunk")
				bmap("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset hunk")
				bmap("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
				bmap("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
				bmap("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
				bmap("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
				bmap("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				bmap("n", "<leader>gd", gs.diffthis, "Diff this")
			end,
		},
	},

	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = { { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" } },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			-- Pass nvim colorscheme colors to lazygit
			local theme = {
				[241] = { fg = "241" },
				activeBorderColor = { fg = "Keyword", bold = true },
				inactiveBorderColor = { fg = "FloatBorder" },
				optionsTextColor = { fg = "Function" },
				selectedLineBgColor = { bg = "Visual" },
				cherryPickedCommitBgColor = { fg = "Identifier" },
				cherryPickedCommitFgColor = { fg = "Function" },
				unstagedChangesColor = { fg = "DiagnosticError" },
				defaultFgColor = { fg = "Normal" },
				searchingActiveBorderColor = { fg = "MatchParen", bold = true },
			}

			local resolved = {}
			for key, def in pairs(theme) do
				for attr, val in pairs(def) do
					if attr ~= "bold" then
						local hl = vim.api.nvim_get_hl(0, { name = val, link = false })
						local color = hl[attr == "fg" and "fg" or "bg"]
						if color then
							def[attr] = string.format("#%06x", color)
						end
					end
				end
				resolved[key] = def
			end

			vim.g.lazygit_config_file_path = {}
			vim.g.lazygit_floating_window_scaling_factor = 0.9
			vim.g.lazygit_use_custom_config_file_path = 0

			-- Set the theme via environment
			local config_dir = vim.fn.stdpath("data") .. "/lazygit"
			vim.fn.mkdir(config_dir, "p")

			local yaml_lines = { "gui:", "  theme:" }
			for key, def in pairs(resolved) do
				local parts = {}
				for attr, val in pairs(def) do
					if attr == "bold" then
						table.insert(parts, '"bold"')
					else
						table.insert(parts, '"' .. val .. '"')
					end
				end
				table.insert(yaml_lines, "    " .. key .. ":")
				for _, p in ipairs(parts) do
					table.insert(yaml_lines, "      - " .. p)
				end
			end

			local config_path = config_dir .. "/theme.yml"
			vim.fn.writefile(yaml_lines, config_path)
			vim.env.LG_CONFIG_FILE = config_path .. "," .. (vim.env.LG_CONFIG_FILE or "")
		end,
	},

	-- Git worktree support
	{
		"ThePrimeagen/git-worktree.nvim",
		keys = {
			{
				"<leader>gw",
				function()
					require("fzf-lua").git_worktrees()
				end,
				desc = "Git worktrees",
			},
		},
		opts = {},
	},
}
