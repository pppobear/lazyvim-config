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

  -- Add keymaps for chezmoi files
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      {
        "<leader>cz",
        function()
          Snacks.picker.files({ cwd = "~/.local/share/chezmoi" })
        end,
        desc = "Chezmoi Files",
      },
    },
  },

  -- Which-key description
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>cz", desc = "Chezmoi Files" },
      },
    },
  },
}
