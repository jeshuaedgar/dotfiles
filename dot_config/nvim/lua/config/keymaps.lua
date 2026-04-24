-- Set calls vim.keymap.set with sensible opts.
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  if opts.silent == nil then
    opts.silent = true
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function unmap(mode, lhs)
  mode = mode or { "n" }
  vim.keymap.del(mode, lhs)
end

-- general
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights after search" })
map("n", "<leader>qq", "<Cmd>qa<CR>", { desc = "[Q]uit all" })

-- editor maps
map("n", "J", function()
  vim.cmd("normal! mzJ`z")
  vim.cmd("delmarks z")
end, { desc = "Join lines but keep cursor position" })
map("v", "p", "pgvy", { desc = "Allow pasting the same selection multiple times" })
map("v", "<", "<gv", { desc = "Go back to visual mode after reindent" })
map("v", ">", ">gv", { desc = "Go back to visual mode after reindent" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<C-c>", '"+y<CR>', { desc = "Copy with Ctrl+C in visual mode" })
map("n", "<BS>", "^", { desc = "Go to first non-whitespace character of the line" })
map("n", "Y", "y$", { desc = "[Y]ank til end of line" })
map("n", "+", "<C-a>", { desc = "Increment" })
map("n", "-", "<C-x>", { desc = "Decrement" })
map("n", "x", '"_x', { desc = "delete char without copying to register" })
map("x", "<leader>p", '"_dP', { desc = "Replaces selected without yanking" })

-- buffer override
unmap("n", "<S-h>")
unmap("n", "<S-l>")

-- scroll up/down from center of screen
map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
