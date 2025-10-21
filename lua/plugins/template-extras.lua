-- Enhanced template editing experience
return {
  -- Better syntax highlighting for mixed file types
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Enable better highlighting for gotmpl injections
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "gotmpl" },
      },
      -- Enable indentation
      indent = {
        enable = true,
      },
    },
  },

  -- Add telescope integration for chezmoi files
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    keys = {
      {
        "<leader>fc",
        function()
          require("telescope.builtin").find_files({
            cwd = vim.fn.expand("~/.local/share/chezmoi"),
            prompt_title = "Chezmoi Files",
          })
        end,
        desc = "Find Chezmoi Files",
      },
      {
        "<leader>fC",
        function()
          require("telescope.builtin").live_grep({
            cwd = vim.fn.expand("~/.local/share/chezmoi"),
            prompt_title = "Grep Chezmoi Files",
          })
        end,
        desc = "Grep Chezmoi Files",
      },
    },
  },

  -- Which-key descriptions
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>fc", desc = "Find Chezmoi Files" },
        { "<leader>fC", desc = "Grep Chezmoi Files" },
      },
    },
  },
}
