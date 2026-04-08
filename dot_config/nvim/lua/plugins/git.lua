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
			local config_dir = vim.fn.stdpath("data") .. "/lazygit"
			vim.fn.mkdir(config_dir, "p")

			-- Moonfly palette
			local fg = "#bdbdbd"
			local green = "#8cc85f"
			local yellow = "#e3c78a"
			local blue = "#80a0ff"
			local cyan = "#79dac8"
			local grey = "#949494"
			local red = "#ff5d5d"

			local theme = {
				activeBorderColor = { green, "bold" },
				inactiveBorderColor = { grey },
				optionsTextColor = { blue },
				selectedLineBgColor = { "#303030" },
				cherryPickedCommitBgColor = { "#303030" },
				cherryPickedCommitFgColor = { cyan },
				unstagedChangesColor = { red },
				defaultFgColor = { fg },
				searchingActiveBorderColor = { yellow, "bold" },
			}

			local lines = {
				"gui:",
				"  nerdFontsVersion: '3'",
				"  border: rounded",
				"  showBottomLine: false",
				"  theme:",
			}
			for key, values in pairs(theme) do
				table.insert(lines, "    " .. key .. ":")
				for _, v in ipairs(values) do
					table.insert(lines, '      - "' .. v .. '"')
				end
			end

			-- Author and branch colors
			vim.tbl_map(function(l)
				table.insert(lines, l)
			end, {
				"  authorColors:",
				'    "*": "' .. blue .. '"',
				"  branchColors:",
				'    "*": "' .. cyan .. '"',
			})

			local config_path = config_dir .. "/config.yml"
			vim.fn.writefile(lines, config_path)

			local user_config = vim.fn.expand("~/Library/Application Support/lazygit/config.yml")
			if vim.fn.filereadable(user_config) == 1 then
				vim.env.LG_CONFIG_FILE = config_path .. "," .. user_config
			else
				vim.env.LG_CONFIG_FILE = config_path
			end
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
