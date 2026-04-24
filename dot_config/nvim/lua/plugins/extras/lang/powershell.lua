return {
  -- treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "powershell" },
      highlight = { enable = true, disable = { "powershell" } },
    },
  },

  -- formatter needs LSP fallback
  -- lsp server needs seperate settings
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        powershell_es = {
          settings = {
            powershell = {
              codeFormatting = {
                Preset = "Stroustrup",
                alignPropertyValuePairs = true,
                whitespaceBeforeOpenParen = true,
                whitespaceBeforeOpenBrace = true,
                whitespaceAroundOperator = true,
                whitespaceAfterSeparator = true,
                whitespaceBetweenParameters = true,
                -- code formatting tweaks
                ignoreOneLineBlock = true,
                addWhitespaceAroundPipe = true,
                trimWhitespaceAroundPipe = true,
                autoCorrectAliases = true,
                whitespaceInsideBrace = false,
              },
            },
          },
        },
      },
    },
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = { ps = { "powershell_es", lsp_format = "prefer" } },
    },
  },
}
