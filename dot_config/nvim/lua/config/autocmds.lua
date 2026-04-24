-- function for augroup
local function augroup(name)
  return vim.api.nvim_create_augroup("jellyvim_" .. name, { clear = true })
end

-- Toggle highlighting current line only in active splits
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter", "VimLeave", "WinLeave", "BufWinLeave" }, {
  group = augroup("toggle_cursorline"),
  desc = "toggle cursorline on focus",
  pattern = "*",
  callback = function(ev)
    vim.opt_local.cursorline = ev.event:find("Enter") ~= nil
  end,
})

-- Custom moonfly highlight for functions
local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "moonfly",
  callback = function()
    vim.api.nvim_set_hl(0, "Function", { fg = "#74b2ff", italic = true })
  end,
  group = custom_highlight,
})

-- trim whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "remove whitespaces on save",
  pattern = "*",
  command = "%s/\\s\\+$//e",
})
