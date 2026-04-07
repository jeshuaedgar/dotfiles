return {
	{
		"mistweaverco/kulala.nvim",
		ft = "http",
		keys = {
			{
				"<leader>rr",
				function()
					require("kulala").run()
				end,
				desc = "Run request",
				ft = "http",
			},
			{
				"<leader>ra",
				function()
					require("kulala").run_all()
				end,
				desc = "Run all requests",
				ft = "http",
			},
			{
				"<leader>re",
				function()
					require("kulala").set_selected_env()
				end,
				desc = "Select env",
				ft = "http",
			},
			{
				"[r",
				function()
					require("kulala").jump_prev()
				end,
				desc = "Prev request",
				ft = "http",
			},
			{
				"]r",
				function()
					require("kulala").jump_next()
				end,
				desc = "Next request",
				ft = "http",
			},
		},
		opts = {},
	},
}
