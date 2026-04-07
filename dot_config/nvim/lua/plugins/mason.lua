return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		keys = {
			{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
		},
		opts = {},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSP servers
				"lua-language-server",
				"typescript-language-server",
				"svelte-language-server",
				"tailwindcss-language-server",
				"pyright",
				"gopls",
				"json-lsp",
				"yaml-language-server",
				"taplo",
				"dockerfile-language-server",
				"docker-compose-language-service",
				"sqls",
				"powershell-editor-services",
				"eslint-lsp",
				"html-lsp",
				"css-lsp",
				"marksman",

				-- Formatters
				"stylua",
				"prettierd",
				"prettier",
				"black",
				"gofumpt",
				"goimports",
				"sql-formatter",

				-- Linters
				"eslint_d",
				"ruff",
				"golangci-lint",
				"markdownlint-cli2",
				"hadolint",
			},
			auto_update = false,
			run_on_start = false,
		},
	},
}
