return {
  {

    "stevearc/oil.nvim",
    dependencies = {
      { "nvim-mini/mini.icons", opts = {} },
      { "refractalize/oil-git-status.nvim" },
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      columns = {
        "mtime",
        "icon",
      },
      win_options = {
        signcolumn = "yes:2",
        winbar = "%!v:lua.get_oil_winbar()",
        conceallevel = 3,
      },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      lsp_file_methods = {
        enabled = true,
        autosave_changes = true,
      },
      constrain_cursor = "editable",
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          local ban_list = { ".DS_Store", ".git", ".." }
          return vim.list_contains(ban_list, name)
        end,
        is_hidden_file = function(name, _)
          local ban_list = { "__pycache__" }
          return vim.list_contains(ban_list, name)
        end,
      },
      keymaps = {
        ["H"] = {
          desc = "Toggle hidden files",
          callback = function()
            require("oil").toggle_hidden()
          end,
        },
        ["<leader>e"] = {
          desc = "Close oil",
          callback = function()
            require("oil").close()
          end,
        },
      },
    },
    config = function(_, opts)
      -- place folder in winbar
      function _G.get_oil_winbar()
        local dir = require("oil").get_current_dir()
        if dir then
          return vim.fn.fnamemodify(dir, ":~")
        else
          return vim.api.nvim_buf_get_name(0)
        end
      end

      require("oil").setup(opts)

      require("oil-git-status").setup({ show_ignored = true })

      -- git integration
      -- set keymap
      vim.keymap.set("n", "<leader>e", function(dir)
        require("oil").open(dir)
      end, { desc = "Open file [e]xplorer" })

      -- rename lsp actions
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })
    end,
  },
  {
    "laytan/cloak.nvim",
    config = function()
      require("cloak").setup({
        enabled = true,
        cloak_character = "*",
        highlight_group = "Comment",
        cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
        try_all_patterns = true,
        cloak_telescope = true,
        cloak_on_leave = false,
        patterns = {
          {
            file_pattern = ".env*",
            cloak_pattern = "=.+",
            replace = nil,
          },
          {
            file_pattern = "local.settings.json",
            cloak_pattern = ":.+",
            replace = nil,
          },
          {
            file_pattern = ".dev.vars*",
            cloak_pattern = "=.+",
            replace = nil,
          },
        },
      })
      -- set keymap for uncloaking
      vim.keymap.set("n", "<leader>cc", "<cmd>CloakPreviewLine<cr>")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<Tab>", "<Cmd>:BufferLineCycleNext<CR>" },
      { "<S-Tab>", "<Cmd>:BufferLineCyclePrev<CR>" },
    },
  },
}
