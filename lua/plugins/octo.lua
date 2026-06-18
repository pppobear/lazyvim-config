return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    keys = {
      { "<leader>go", "<cmd>Octo<cr>", desc = "Octo: commands" },
      { "<leader>gpl", "<cmd>Octo pr list<cr>", desc = "Octo: list PRs" },
      { "<leader>gpu", "<cmd>Octo pr url<cr>", desc = "Octo: copy PR URL" },
      { "<leader>gpb", "<cmd>Octo pr browser<cr>", desc = "Octo: open PR in browser" },
      { "<leader>gpc", "<cmd>Octo pr checkout<cr>", desc = "Octo: checkout PR" },
      { "<leader>gpr", "<cmd>Octo review start<cr>", desc = "Octo: start review" },
      { "<leader>gps", "<cmd>Octo review submit<cr>", desc = "Octo: submit review" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enable_builtin = true,
      picker = "snacks",
      use_local_fs = true,
      default_remote = { "origin", "upstream" },
      default_merge_method = "merge",
      default_delete_branch = false,
    },
  },
}
