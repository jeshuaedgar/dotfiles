return {
	-- Fuzzy finder
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		dependencies = { "echasnovski/mini.icons" },
		keys = {
			-- Find
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
			{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
			{ "<leader>fc", "<cmd>FzfLua command_history<cr>", desc = "Command history" },
			{ "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Symbols" },
			{ "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
			{ "<leader>ft", "<cmd>TodoFzfLua<cr>", desc = "Todo comments" },
			-- Search
			{ "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
			{ "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Search grep" },
			{ "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Word under cursor" },
			{ "<leader>sW", "<cmd>FzfLua grep_cWORD<cr>", desc = "WORD under cursor" },
			{ "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics (buffer)" },
			{ "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics (workspace)" },
			{ "<leader>sr", "<cmd>FzfLua resume<cr>", desc = "Resume last search" },
			-- LSP
			{ "gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "Goto definition" },
			{ "grr", "<cmd>FzfLua lsp_references<cr>", desc = "References" },
			{ "gri", "<cmd>FzfLua lsp_implementations<cr>", desc = "Implementations" },
			{ "grt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "Type definitions" },
		},
		opts = {
			defaults = {
				formatter = "path.filename_first",
			},
			fzf_colors = true,
			files = {
				cwd_prompt = false,
				git_icons = true,
			},
			grep = {
				rg_glob = true,
			},
			winopts = {
				height = 0.80,
				width = 0.85,
				preview = {
					layout = "horizontal",
					horizontal = "right:50%",
				},
			},
		},
	},

	-- File explorer
	{
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = {
			{ "echasnovski/mini.icons", opts = {} },
			{ "refractalize/oil-git-status.nvim" },
		},
		opts = {
			default_file_explorer = true,
			columns = { "mtime", "icon" },
			win_options = {
				signcolumn = "yes:2",
				winbar = "%!v:lua.get_oil_winbar()",
				conceallevel = 3,
			},
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			lsp_file_methods = {
				enabled = true,
				autosave_changes = true,
			},
			constrain_cursor = "editable",
			watch_for_changes = true,
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					return vim.list_contains({ ".DS_Store", ".git", ".." }, name)
				end,
				is_hidden_file = function(name, _)
					return vim.list_contains({ "__pycache__" }, name)
				end,
			},
			keymaps = {
				["H"] = {
					desc = "Toggle hidden files",
					callback = function()
						require("oil").toggle_hidden()
					end,
				},
				["<leader>e"] = {
					desc = "Close oil",
					callback = function()
						require("oil").close()
					end,
				},
			},
		},
		config = function(_, opts)
			function _G.get_oil_winbar()
				local dir = require("oil").get_current_dir()
				if dir then
					return vim.fn.fnamemodify(dir, ":~")
				end
				return vim.api.nvim_buf_get_name(0)
			end
			require("oil").setup(opts)
			require("oil-git-status").setup({ show_ignored = true })
		end,
	},

	-- Flash (fast navigation)
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash treesitter",
			},
		},
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Prev todo",
			},
		},
	},

	-- Cloak (env file hiding)
	{
		"laytan/cloak.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			cloak_length = nil,
			try_all_patterns = true,
			cloak_telescope = true,
			cloak_on_leave = false,
			patterns = {
				{ file_pattern = ".env*", cloak_pattern = "=.+", replace = nil },
				{ file_pattern = "local.settings.json", cloak_pattern = ":.+", replace = nil },
				{ file_pattern = ".dev.vars*", cloak_pattern = "=.+", replace = nil },
			},
		},
	},

	-- JSON/YAML schemas
	{ "b0o/schemastore.nvim", lazy = true },

	-- Render markdown
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons",
		},
		keys = {
			{ "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
		},
		opts = {},
	},

	-- Better quickfix
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {
			preview = { winblend = 0 },
		},
	},

	-- Project-wide search and replace
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					require("grug-far").open({ transient = true })
				end,
				desc = "Search and replace",
			},
			{
				"<leader>sr",
				function()
					require("grug-far").with_visual_selection({ transient = true })
				end,
				mode = "v",
				desc = "Search and replace (selection)",
			},
		},
		opts = {
			headerMaxWidth = 80,
		},
	},

	-- Auto close stale buffers
	{
		"chrisgrieser/nvim-early-retirement",
		event = "VeryLazy",
		opts = {
			retirementAgeMins = 20,
			notificationOnAutoClose = true,
		},
	},
}
