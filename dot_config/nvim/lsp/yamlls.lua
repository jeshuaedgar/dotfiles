return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose" },
	root_markers = { ".git" },
	on_init = function(client)
		local ok, schemastore = pcall(require, "schemastore")
		if ok then
			client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
				yaml = {
					schemas = schemastore.yaml.schemas(),
					validate = true,
					schemaStore = { enable = false, url = "" },
				},
			})
		end
	end,
}
