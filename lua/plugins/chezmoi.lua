-- Chezmoi template support with Go template syntax highlighting
return {
  -- Add gotmpl (Go template) parser to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure opts.ensure_installed exists
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "gotmpl", "bash" })
      else
        opts.ensure_installed = { "gotmpl", "bash" }
      end
    end,
  },

  -- Optional: LSP support for templates
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- gopls can provide some template support
        gopls = {
          settings = {
            gopls = {
              templateExtensions = { "tmpl", "gotmpl" },
            },
          },
        },
      },
    },
  },
}
