local toggle_key = "<C-,>"
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code", mode = { "n", "x" } },
    },
    opts = {
      terminal = {
        provider = "external",
        provider_opts = {
          external_terminal_cmd = "kitty -e %s",
        },
      },
    },
  },
}
