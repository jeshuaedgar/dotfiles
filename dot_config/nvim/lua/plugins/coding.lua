return {
	-- Surround
	{ "echasnovski/mini.surround", event = { "BufReadPost", "BufNewFile" }, opts = {} },

	-- Better text objects
	{
		"echasnovski/mini.ai",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			n_lines = 500,
			custom_textobjects = {
				g = function()
					local from = { line = 1, col = 1 }
					local to = {
						line = vim.fn.line("$"),
						col = math.max(vim.fn.getline("$"):len(), 1),
					}
					return { from = from, to = to }
				end,
			},
		},
	},

	-- Auto pairs
	{ "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },

	-- Highlight patterns (colors, TODO, etc)
	{
		"echasnovski/mini.hipatterns",
		event = { "BufReadPost", "BufNewFile" },
		opts = function()
			local hi = require("mini.hipatterns")
			return {
				highlighters = {
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
					hex_color = hi.gen_highlighter.hex_color(),
				},
			}
		end,
	},

	-- Auto close/rename HTML tags
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
}
