return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				desc = "Format",
			},
			{
				"<leader>cF",
				function()
					require("conform").format({ async = true, lsp_fallback = true, formatters = {} })
				end,
				desc = "Format (LSP only)",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua", lsp_format = "fallback" },
				-- OXC: oxfmt for JS/TS, falls back to prettierd/prettier
				javascript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
				typescript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
				svelte = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				jsonc = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				scss = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				python = { "black", lsp_format = "fallback" },
				go = { "gofumpt", "goimports", lsp_format = "fallback" },
				toml = { "taplo", lsp_format = "fallback" },
				sql = { "sql_formatter" },
				ps1 = { lsp_format = "prefer" },
				["_"] = { "trim_whitespace" },
			},
			formatters = {
				oxfmt = {
					command = "oxfmt",
					args = { "--stdin", "$FILENAME" },
					stdin = true,
				},
			},
			format_on_save = function(bufnr)
				local ignore_filetypes = { "sql" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				return {
					timeout_ms = 1000,
					lsp_fallback = true,
				}
			end,
			notify_on_error = true,
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
