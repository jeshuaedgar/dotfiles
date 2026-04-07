vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("core.options")
require("core.keymaps")
require("core.autocmds")

vim.lsp.enable({
	"ts_ls",
	"svelte",
	"tailwindcss",
	"pyright",
	"gopls",
	"lua_ls",
	"jsonls",
	"yamlls",
	"taplo",
	"dockerls",
	"docker_compose_language_service",
	"sqls",
	"powershell_es",
	"eslint",
	"html",
	"cssls",
	"marksman",
})

-- lazy.nvim auto-discovers all files in lua/plugins/
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	defaults = { lazy = true },
	install = { colorscheme = { "moonfly", "habamax" } },
	checker = { enabled = false },
	change_detection = { notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
