return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      picker = {
        win = {
          input = {
            keys = {
              ["<C-]>"] = { "cycle_win", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<C-]>"] = "cycle_win",
            },
          },
          preview = {
            keys = {
              ["<C-]>"] = "cycle_win",
            },
          },
        },
      },
    },
  },
}
