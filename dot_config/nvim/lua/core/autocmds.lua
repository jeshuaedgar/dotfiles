local function augroup(name)
	return vim.api.nvim_create_augroup("jellyvim_" .. name, { clear = true })
end

-- Toggle cursorline only in active window
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter", "VimLeave", "WinLeave", "BufWinLeave" }, {
	group = augroup("toggle_cursorline"),
	desc = "Toggle cursorline on focus",
	pattern = "*",
	callback = function(ev)
		vim.opt_local.cursorline = ev.event:find("Enter") ~= nil
	end,
})

-- Custom moonfly highlight for functions
vim.api.nvim_create_autocmd("ColorScheme", {
	group = augroup("custom_highlight"),
	pattern = "moonfly",
	callback = function()
		vim.api.nvim_set_hl(0, "Function", { fg = "#74b2ff", italic = true })
	end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("trim_whitespace"),
	desc = "Remove trailing whitespace on save",
	pattern = "*",
	command = "%s/\\s\\+$//e",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("yank_highlight"),
	callback = function()
		vim.hl.on_yank({ timeout = 200 })
	end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("restore_cursor"),
	callback = function(event)
		local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
		local lcount = vim.api.nvim_buf_line_count(event.buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Auto-resize splits on terminal resize
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Close some filetypes with q
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = { "help", "man", "qf", "checkhealth", "notify", "git" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Auto-create parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Chezmoi auto-apply on save
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup("chezmoi_apply"),
	pattern = vim.fn.expand("~") .. "/.local/share/chezmoi/*",
	callback = function()
		vim.fn.jobstart({ "chezmoi", "apply", "--source-path", vim.fn.expand("%:p") }, {
			on_exit = function(_, code)
				if code == 0 then
					vim.notify("chezmoi applied", vim.log.levels.INFO)
				end
			end,
		})
	end,
})

-- Detect docker-compose files as yaml.docker-compose
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("docker_compose_ft"),
	pattern = { "docker-compose*.yml", "docker-compose*.yaml", "compose*.yml", "compose*.yaml" },
	callback = function()
		vim.bo.filetype = "yaml.docker-compose"
	end,
})

-- Auto-reload files changed outside nvim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("auto_reload"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Big file performance (disable features for large files)
vim.api.nvim_create_autocmd("BufReadPre", {
	group = augroup("big_file"),
	callback = function(ev)
		local max_filesize = 1024 * 1024 -- 1MB
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
		if ok and stats and stats.size > max_filesize then
			vim.bo[ev.buf].syntax = ""
			vim.cmd("syntax off")
			pcall(vim.treesitter.stop, ev.buf)
			vim.bo[ev.buf].undofile = false
			vim.bo[ev.buf].swapfile = false
			vim.b[ev.buf].large_file = true
			vim.notify("Large file detected — disabling heavy features", vim.log.levels.WARN)
		end
	end,
})

-- Enable inlay hints when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("inlay_hints"),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
	end,
})

-- Enable treesitter highlighting for non-bundled languages
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("treesitter_start"),
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})

-- Chezmoi: detect template files and set filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("chezmoi_ft"),
	pattern = vim.fn.expand("~") .. "/.local/share/chezmoi/*",
	callback = function(ev)
		-- Strip .tmpl extension for filetype detection
		local name = vim.fn.fnamemodify(ev.match, ":t")
		if name:match("%.tmpl$") then
			local real_name = name:gsub("%.tmpl$", "")
			local ft = vim.filetype.match({ filename = real_name })
			if ft then
				vim.bo[ev.buf].filetype = ft
			end
		end
	end,
})
