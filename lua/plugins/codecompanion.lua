-- codecompanion.nvim - AI coding assistant for Neovim
return {
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion: actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion: chat" },
      { "<leader>ad", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "CodeCompanion: add selection" },
      { "<leader>ai", "<cmd>CodeCompanion ", mode = { "n", "v" }, desc = "CodeCompanion: inline prompt" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "ibhagwan/fzf-lua",
        init = function()
          local runtime_dir = vim.env.XDG_RUNTIME_DIR
          if runtime_dir and runtime_dir ~= "" and vim.fn.isdirectory(runtime_dir) == 0 then
            vim.fn.mkdir(runtime_dir, "p", "0700")
          end
        end,
      },
    },
    opts = {
      adapters = {
        acp = {
          pi = function()
            return require("codecompanion.adapters").extend("codex", {
              name = "pi",
              formatted_name = "Pi",
              commands = {
                default = {
                  "pi-acp",
                },
              },
              defaults = {
                mcpServers = {},
                timeout = 20000,
              },
              env = {},
            })
          end,
        },
      },
      display = {
        action_palette = {
          provider = "fzf_lua",
        },
        chat = {
          window = {
            layout = "vertical",
            position = "right",
            width = 0.35,
          },
        },
      },
      strategies = {
        chat = {
          adapter = "pi",
        },
        inline = {
          adapter = "copilot",
        },
        cmd = {
          adapter = "copilot",
        },
      },
    },
  },
}
