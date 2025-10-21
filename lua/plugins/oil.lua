-- oil.nvim - A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer
return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local detail = false
      require("oil").setup({
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        default_file_explorer = true,

        -- Send deleted files to the trash instead of permanently deleting them
        delete_to_trash = true,

        -- Skip the confirmation popup for simple operations
        skip_confirm_for_simple_edits = true,

        -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
        prompt_save_on_select_new_entry = true,

        -- Columns to display in oil buffer
        columns = {
          "icon",
          -- "permissions",
          -- "size",
          -- "mtime",
        },

        -- Keymaps in oil buffer
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
          ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
              detail = not detail
              if detail then
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end,
          },
        },

        -- Set to false to disable all of the above keymaps
        use_default_keymaps = true,

        view_options = {
          -- Show files and directories that start with "."
          show_hidden = false,

          -- This function defines what is considered a "hidden" file
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,

          -- This function defines what will never be shown, even when `show_hidden` is true
          is_always_hidden = function(name, bufnr)
            return false
          end,

          -- Sort file names in a more intuitive order for humans
          natural_order = true,

          sort = {
            -- sort order can be "asc" or "desc"
            { "type", "asc" },
            { "name", "asc" },
          },
        },

        -- Window options for oil buffers
        -- Required for oil-git-status to display git status in sign column
        win_options = {
          signcolumn = "yes:2", -- Show 2 sign columns for git status (index + working tree)
        },

        -- Configuration for the floating window in oil.open_float
        float = {
          -- Padding around the floating window
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          override = function(conf)
            return conf
          end,
        },

        -- Configuration for the actions floating preview window
        preview = {
          -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          max_width = 0.9,
          -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
          min_width = { 40, 0.4 },
          -- optionally define an integer/float for the exact width of the preview window
          width = nil,
          -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },

        -- Configuration for the floating progress window
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          minimized_border = "none",
          win_options = {
            winblend = 0,
          },
        },
      })
    end,
    -- Lazy load when opening a directory
    lazy = false,
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
        desc = "Open parent directory",
      },
      {
        "<leader>-",
        function()
          require("oil").open_float()
        end,
        desc = "Open parent directory (float)",
      },
      {
        "<leader>e",
        function()
          require("oil").open()
        end,
        desc = "Open file explorer",
      },
      {
        "<leader>E",
        function()
          require("oil").open_float()
        end,
        desc = "Open file explorer (float)",
      },
    },
  },

  {
    "benomahony/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
    -- No opts or config needed! Works automatically
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
}
