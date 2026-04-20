return {
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      -- Light background to match Ghostty's Everforest Light Med
      vim.o.background = "light"

      -- Background contrast: 'hard', 'medium', 'soft' (matches Ghostty's "Med")
      vim.g.everforest_background = "medium"

      -- Enable italic keywords and comments
      vim.g.everforest_enable_italic = 1

      -- Better performance
      vim.g.everforest_better_performance = 1

      -- Diagnostic text highlighting style
      vim.g.everforest_diagnostic_text_highlight = 1

      -- Diagnostic line highlighting style
      vim.g.everforest_diagnostic_line_highlight = 1

      -- Diagnostic virtual text
      vim.g.everforest_diagnostic_virtual_text = "colored"

      -- Sign column background
      vim.g.everforest_sign_column_background = "none"

      -- Transparent background for floating windows
      vim.g.everforest_float_style = "bright"

      -- Spell check foreground
      vim.g.everforest_spell_foreground = "none"
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
