local function acp(command, args, env)
  return {
    command = command,
    args = args,
    env = env,
  }
end

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = vim.fn.has("win32") == 1
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "HakonHarnes/img-clip.nvim",
    },
    config = function(_, opts)
      require("avante").setup(opts)

      local function provider_names()
        local config = require("avante.config")
        local names = {}

        for name, _ in pairs(config.providers or {}) do
          names[#names + 1] = name
        end
        for name, _ in pairs(config.acp_providers or {}) do
          if not vim.tbl_contains(names, name) then
            names[#names + 1] = name
          end
        end

        table.sort(names)
        return names
      end

      pcall(vim.api.nvim_del_user_command, "AvanteSwitchProvider")
      vim.api.nvim_create_user_command("AvanteSwitchProvider", function(cmd_opts)
        local target = vim.trim(cmd_opts.args or "")
        if target ~= "" then
          require("avante.api").switch_provider(target)
          return
        end

        vim.ui.select(provider_names(), { prompt = "Provider> " }, function(choice)
          if choice and choice ~= "" then
            require("avante.api").switch_provider(choice)
          end
        end)
      end, {
        nargs = "?",
        desc = "avante: switch provider",
        complete = function(_, line)
          local prefix = line:match("AvanteSwitchProvider%s*(.*)$") or ""
          return vim.tbl_filter(function(name)
            return name:find(prefix, 1, true) == 1
          end, provider_names())
        end,
      })
    end,
    opts = {
      provider = "claude-code",
      auto_suggestions_provider = "claude-code",
      selector = {
        provider = "snacks",
      },
      acp_providers = {
        ["gemini-cli"] = acp("gemini", {
          "--experimental-acp",
        }, {
          NODE_NO_WARNINGS = "1",
          GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
        }),
        ["claude-code"] = acp("npx", {
          "-y",
          "-g",
          "@zed-industries/claude-code-acp",
        }, {
          NODE_NO_WARNINGS = "1",
          HOME = os.getenv("HOME"),
          PATH = os.getenv("PATH"),
          ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
          ACP_PERMISSION_MODE = "bypassPermissions",
        }),
        goose = acp("goose", {
          "acp",
        }),
        codex = acp("npx", {
          "-y",
          "-g",
          "@zed-industries/codex-acp",
        }, {
          NODE_NO_WARNINGS = "1",
          HOME = os.getenv("HOME"),
          PATH = os.getenv("PATH"),
        }),
        cursor = acp("npx", {
          "-y",
          "@blowmage/cursor-agent-acp",
        }, {
          NODE_NO_WARNINGS = "1",
          HOME = os.getenv("HOME"),
          PATH = os.getenv("PATH"),
        }),
      },
    },
  },
}
