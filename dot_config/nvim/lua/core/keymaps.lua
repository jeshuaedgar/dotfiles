local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	if opts.silent == nil then
		opts.silent = true
	end
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- =====================
-- General
-- =====================
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights after search" })
map("n", "<leader>qq", "<Cmd>qa<CR>", { desc = "Quit all" })
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map("n", "<leader>w", "<cmd>wall ++p<cr>", { desc = "Save all (create dirs)" })

-- =====================
-- Editor
-- =====================
map("n", "J", function()
	vim.cmd("normal! mzJ`z")
	vim.cmd("delmarks z")
end, { desc = "Join lines but keep cursor position" })

map("n", "<BS>", "^", { desc = "Go to first non-whitespace character" })
map("n", "Y", "y$", { desc = "Yank til end of line" })
map("n", "+", "<C-a>", { desc = "Increment" })
-- NOTE: "-" is now free since oil uses <leader>e
-- If you want decrement on "-", uncomment:
-- map("n", "-", "<C-x>", { desc = "Decrement" })
-- If you want oil on "-", keep this instead:
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "x", '"_x', { desc = "Delete char without copying to register" })

-- =====================
-- Visual mode
-- =====================
map("v", "p", "pgvy", { desc = "Paste and re-yank (paste same thing multiple times)" })
map("v", "<", "<gv", { desc = "Reindent and stay in visual" })
map("v", ">", ">gv", { desc = "Reindent and stay in visual" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<C-c>", '"+y<CR>', { desc = "Copy to system clipboard" })
map("x", "<leader>p", '"_dP', { desc = "Replace selected without yanking" })

-- =====================
-- Buffers (Tab / S-Tab, no S-h / S-l)
-- =====================
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader><leader>", "<cmd>b#<cr>", { desc = "Alternate buffer" })

-- =====================
-- Scroll (centered)
-- =====================
map("n", "<C-d>", "<C-d>zz", { noremap = true, desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { noremap = true, desc = "Scroll up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search (centered)" })

-- =====================
-- Windows
-- =====================
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- =====================
-- Quickfix
-- =====================
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })

-- =====================
-- Diagnostics
-- =====================
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
map("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Prev diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- =====================
-- File explorer
-- =====================
map("n", "<leader>e", function()
	require("oil").open()
end, { desc = "Open file explorer" })

-- =====================
-- Cloak
-- =====================
map("n", "<leader>cc", "<cmd>CloakPreviewLine<cr>", { desc = "Cloak preview line" })

-- =====================
-- LSP (on attach)
-- =====================
-- 0.12 defaults you get for free:
--   grn = rename        gra = code action     grr = references
--   gri = implementation  grt = type definition   grx = codelens run
--   gO  = document symbols  K = hover
--   CTRL-S (insert) = signature help
--
-- We add only what's missing:
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
	callback = function(ev)
		local function bmap(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
		end

		bmap("n", "gd", vim.lsp.buf.definition, "Goto definition")
		bmap("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
		bmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
		bmap("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
		bmap("n", "<leader>cf", function()
			vim.lsp.buf.format({ async = true })
		end, "Format (LSP)")
		-- Completion handled by blink.cmp, no vim.lsp.completion.enable needed
	end,
})

-- Quick access to config
map("n", "<leader>oc", function()
	require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Open config files" })

-- Quick split management
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })

-- Toggle diagnostics
map("n", "<leader>ud", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- Toggle inlay hints (0.12)
map("n", "<leader>uh", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- Toggle word wrap
map("n", "<leader>uw", function()
	vim.wo.wrap = not vim.wo.wrap
	vim.notify("Wrap: " .. tostring(vim.wo.wrap))
end, { desc = "Toggle word wrap" })

-- List LSP's
map("n", "<leader>cl", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP clients attached", vim.log.levels.WARN)
		return
	end
	for _, c in ipairs(clients) do
		vim.notify(string.format("%s (id: %d)", c.name, c.id), vim.log.levels.INFO)
	end
end, { desc = "LSP clients" })

-- Undotree (builtin 0.12)
map("n", "<leader>uu", function()
	vim.cmd("packadd nvim.undotree")
	vim.cmd("Undotree")
end, { desc = "Undo tree" })

-- Difftool (builtin 0.12)
map("n", "<leader>od", function()
	vim.cmd("packadd nvim.difftool")
	vim.ui.input({ prompt = "Compare with: " }, function(path)
		if path and path ~= "" then
			vim.cmd("DiffTool " .. vim.fn.expand("%") .. " " .. path)
		end
	end)
end, { desc = "Diff with file" })
