return {
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 900,
		opts = {
			notifier = { enabled = true, timeout = 3000 },
			scroll = { enabled = false },
			input = { enabled = true },
			indent = { enabled = true },
			dashboard = { enabled = true },
		},
		keys = {
			{
				"<leader>un",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification history",
			},
			{
				"<leader>nd",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss notifications",
			},
		},
	},
}
