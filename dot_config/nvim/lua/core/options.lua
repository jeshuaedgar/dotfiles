local opt = vim.opt

-- General
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10

-- 0.12 builtin float/pum borders
opt.winborder = "rounded"
opt.pumborder = "rounded"

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Wrapping
opt.wrap = false
opt.breakindent = true
opt.linebreak = true

-- Folding (treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Grep
opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"

-- Diagnostic
vim.diagnostic.config({
	severity_sort = true,
	float = { source = true },
	virtual_text = { spacing = 4, prefix = "●" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
})

-- Better diff
opt.diffopt:append({ "algorithm:histogram", "linematch:60" })

-- Fill charachters:
opt.fillchars = {
	eob = " ", -- end of buffer
	fold = " ", -- folding
	foldopen = " ", -- open fold
	foldclose = " ", -- closed fold
	foldsep = " ", -- fold separator
	diff = " ", -- deleted lines in diff
}

-- Snippet tabstop highlight (0.12)
vim.api.nvim_set_hl(0, "SnippetTabstop", { bg = "#2a2a3a" })

-- 0.12: enable completion in search (/, ?, :g, :v)
opt.wildchar = ("<Tab>"):byte()
opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy", "nearest" }
