return {
  {
    "sainnhe/sonokai",
    priority = 1000,
    config = function()
      -- Available styles: 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
      vim.g.sonokai_style = "default"

      -- Enable italic keywords and comments
      vim.g.sonokai_enable_italic = 1

      -- Disable italic in strings
      vim.g.sonokai_disable_italic_comment = 0

      -- Enable bold
      vim.g.sonokai_enable_bold = 1

      -- Transparent background (set to 1 to enable)
      vim.g.sonokai_transparent_background = 0

      -- Better performance
      vim.g.sonokai_better_performance = 1

      -- Diagnostic text highlighting style
      -- Options: 'grey', 'colored'
      vim.g.sonokai_diagnostic_text_highlight = 1

      -- Diagnostic line highlighting style
      vim.g.sonokai_diagnostic_line_highlight = 1

      -- Diagnostic virtual text
      vim.g.sonokai_diagnostic_virtual_text = "colored"

      -- Cursor color
      vim.g.sonokai_cursor = "auto"

      -- Diff mode colors
      vim.g.sonokai_spell_foreground = "none"

      -- Menu selection
      vim.g.sonokai_menu_selection_background = "blue"

      -- Sign column background
      vim.g.sonokai_sign_column_background = "none"

      -- Transparent background for floating windows
      vim.g.sonokai_float_style = "bright"
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "sonokai",
    },
  },
}
