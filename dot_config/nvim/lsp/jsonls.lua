return {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { ".git" },
	on_init = function(client)
		local ok, schemastore = pcall(require, "schemastore")
		if ok then
			client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
				json = {
					schemas = schemastore.json.schemas(),
					validate = { enable = true },
				},
			})
		end
	end,
}
