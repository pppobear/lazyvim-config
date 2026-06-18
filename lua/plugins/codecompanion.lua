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
        http = {
          ["litellm-fast"] = function()
            local pi_dir = "/Users/enoch/.pi"

            local function agent_dir()
              return pi_dir .. "/agent"
            end

            local function read_json(path)
              local ok, lines = pcall(vim.fn.readfile, path)
              if not ok then
                return nil
              end

              local decoded_ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
              if decoded_ok then
                return decoded
              end
            end

            local function litellm_config()
              local models = read_json(agent_dir() .. "/models.json")
              return models and models.providers and models.providers.litellm or {}
            end

            local function model_choices()
              local choices = {}
              for _, model in ipairs(litellm_config().models or {}) do
                if model.id then
                  choices[model.id] = { opts = {} }
                end
              end
              return choices
            end

            local function default_model()
              local choices = model_choices()
              return choices["gpt-5.4-mini"] and "gpt-5.4-mini" or "gpt-5.5"
            end

            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "litellm-fast",
              formatted_name = "LiteLLM Fast",
              env = {
                api_key = litellm_config().apiKey,
                url = litellm_config().baseUrl or "https://litellm.wenext.technology/v1",
                chat_url = "/chat/completions",
                models_endpoint = "/models",
              },
              schema = {
                model = {
                  default = default_model,
                  choices = model_choices,
                },
              },
            })
          end,
        },
        acp = {
          pi = function()
            local adapter = require("codecompanion.adapters").extend("codex", {
              name = "pi",
              formatted_name = "Pi",
              commands = {
                default = {
                  "pi-acp",
                },
              },
              defaults = {
                auth_method = "agent",
                mcpServers = {},
                timeout = 20000,
              },
            })

            adapter.env = {}

            return adapter
          end,
          omp = function()
            local helpers = require("codecompanion.adapters.acp.helpers")

            return {
              name = "omp",
              formatted_name = "OMP",
              type = "acp",
              roles = {
                llm = "assistant",
                user = "user",
              },
              commands = {
                default = {
                  "/Users/enoch/.bun/bin/omp",
                  "acp",
                },
              },
              defaults = {
                auth_method = "agent",
                mcpServers = {},
                timeout = 20000,
              },
              parameters = {
                protocolVersion = 1,
                clientCapabilities = {
                  fs = { readTextFile = true, writeTextFile = true },
                },
                clientInfo = {
                  name = "CodeCompanion.nvim",
                  version = "1.0.0",
                },
              },
              handlers = {
                setup = function()
                  return true
                end,
                form_messages = function(self, messages, capabilities)
                  return helpers.form_messages(self, messages, capabilities)
                end,
                on_exit = function() end,
              },
            }
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
          adapter = "litellm-fast",
        },
        cmd = {
          adapter = "pi",
        },
      },
    },
  },
}
