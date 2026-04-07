return {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"svelte",
	},
	root_markers = {
		"eslint.config.js",
		"eslint.config.mjs",
		"eslint.config.cjs",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.json",
		".eslintrc",
		"package.json",
	},
	settings = {
		validate = "on",
		format = false,
		codeActionOnSave = { enable = false },
		workingDirectories = { mode = "auto" },
	},
	on_init = function(client)
		client.server_capabilities.diagnosticProvider = nil
	end,
	on_attach = function(_, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.code_action({
					context = { only = { "source.fixAll.eslint" }, diagnostics = {} },
					apply = true,
				})
			end,
		})
	end,
}
