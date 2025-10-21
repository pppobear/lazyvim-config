-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.colorcolumn = "0"
vim.opt.cursorlineopt = "number"
vim.opt.textwidth = 80
vim.opt.whichwrap = "<,>,[,]"
vim.opt.numberwidth = 4
vim.opt.pumwidth = 80

-- Chezmoi template filetype detection
vim.filetype.add({
  pattern = {
    [".*%.tmpl"] = {
      function(path, bufnr)
        local filename = vim.fn.fnamemodify(path, ":t")

        -- Remove chezmoi prefixes
        local real_name = filename
          :gsub("^private_", "")
          :gsub("^readonly_", "")
          :gsub("^executable_", "")
          :gsub("^symlink_", "")
          :gsub("^dot_", ".")
          :gsub("%.tmpl$", "")

        -- Exact matches
        local exact_map = {
          [".gitconfig"] = "gitconfig",
          [".gitignore"] = "gitignore",
          [".zshrc"] = "zsh",
          [".zshenv"] = "zsh",
          [".bashrc"] = "bash",
          [".bash_profile"] = "bash",
          [".vimrc"] = "vim",
          [".tmux.conf"] = "tmux",
        }

        if exact_map[real_name] then
          return exact_map[real_name]
        end

        -- Extension-based
        local ext = real_name:match("%.([^.]+)$")
        if ext then
          local ext_map = {
            sh = "sh", bash = "bash", zsh = "zsh", fish = "fish",
            yaml = "yaml", yml = "yaml", toml = "toml", json = "json",
            xml = "xml", conf = "conf", ini = "dosini", py = "python",
            rb = "ruby", lua = "lua", vim = "vim", js = "javascript",
            ts = "typescript", md = "markdown",
          }
          return ext_map[ext] or "gotmpl"
        end

        return "gotmpl"
      end,
      { priority = math.huge },
    },
  },
})
