return {
  -- add gruvbox
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "moonfly",
    },
  },
}
