return {
  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    opts = {
      terminal = {
        provider = "external",
        provider_opts = {
          external_terminal_cmd = function(cmd, _env)
            -- Reuse existing Claude Code tmux pane if it's still alive
            if vim.g._claude_pane_id then
              local alive = vim.trim(vim.fn.system(
                "tmux display-message -t " .. vim.g._claude_pane_id .. " -p '#{pane_id}' 2>/dev/null"
              ))
              if alive ~= "" then
                return "tmux select-pane -t " .. vim.g._claude_pane_id
              end
              vim.g._claude_pane_id = nil
            end
            -- Create new pane in background (-d) so we can capture its ID
            local pane_id = vim.trim(vim.fn.system(
              "tmux split-window -h -l 40% -d -P -F '#{pane_id}' " .. vim.fn.shellescape(cmd)
            ))
            if pane_id ~= "" then
              vim.g._claude_pane_id = pane_id
              return "tmux select-pane -t " .. pane_id
            end
            -- Fallback: just open normally
            return "tmux split-window -h -l 40% " .. cmd
          end,
        },
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  {
    "pittcat/claude-fzf.nvim",
    build = "rm -f doc/claude-fzf-zh.txt && helptags doc/",
    dependencies = {
      "ibhagwan/fzf-lua",
      "coder/claudecode.nvim",
    },
    cmd = {
      "ClaudeFzf",
      "ClaudeFzfFiles",
      "ClaudeFzfGrep",
      "ClaudeFzfBuffers",
      "ClaudeFzfGitFiles",
      "ClaudeFzfDirectory",
    },
    keys = {
      { "<leader>cf", "<cmd>ClaudeFzfFiles<cr>", desc = "Claude FZF files" },
      { "<leader>cg", "<cmd>ClaudeFzfGrep<cr>", desc = "Claude FZF grep" },
      { "<leader>cb", "<cmd>ClaudeFzfBuffers<cr>", desc = "Claude FZF buffers" },
      { "<leader>cG", "<cmd>ClaudeFzfGitFiles<cr>", desc = "Claude: Add Git files" },
      { "<leader>cd", "<cmd>ClaudeFzfDirectory<cr>", desc = "Claude: Add directory files" },
    },
    opts = {},
  },
}
