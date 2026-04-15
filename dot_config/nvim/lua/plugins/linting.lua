return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			-- Custom oxlint linter config
			lint.linters.oxlint = {
				name = "oxlint",
				cmd = "oxlint",
				args = {
					"--format",
					"unix",
					"--quiet",
				},
				stdin = false,
				stream = "stdout",
				ignore_exitcode = true,
				parser = function(output, bufnr)
					local diagnostics = {}
					local fname = vim.api.nvim_buf_get_name(bufnr)

					for line in output:gmatch("[^\n]+") do
						-- Unix format: filename:line:col: message
						local file, lnum, col, msg = line:match("^(.+):(%d+):(%d+): (.+)$")
						if file and (file == fname or vim.endswith(fname, file)) then
							local severity = vim.diagnostic.severity.WARN
							if msg:match("^error") or msg:match("Error") then
								severity = vim.diagnostic.severity.ERROR
							end
							table.insert(diagnostics, {
								lnum = tonumber(lnum) - 1,
								col = tonumber(col) - 1,
								message = msg,
								severity = severity,
								source = "oxlint",
							})
						end
					end

					return diagnostics
				end,
			}

			lint.linters_by_ft = {
				-- OXC: oxlint for JS/TS files
				javascript = { "oxlint" },
				typescript = { "oxlint" },
				typescriptreact = { "oxlint" },
				javascriptreact = { "oxlint" },
				-- Other linters
				python = { "ruff" },
				go = { "golangcilint" },
				markdown = { "markdownlint-cli2" },
				dockerfile = { "hadolint" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("Linting", { clear = true }),
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
