return {
  {
    "nvim-treesitter",
    keys = {
      { "<cr>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<cr>",
          node_incremental = "<cr>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
}
