return {
  "fabridamicelli/cronex.nvim",
  opts = {},
  setup = function(_, opts)
    require("cronex").setup({
      file_patterns = { "*.yaml", "*.yml", "*.tf", "*.cfg", "*.config", "*.conf", "wrangler.jsonc" },
    })
  end,
}
