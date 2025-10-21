-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 3
  end,
})

-- Chezmoi template file detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tmpl" },
  callback = function()
    local filename = vim.fn.expand("%:t")

    -- Remove chezmoi prefixes to get the real filename
    -- dot_ -> .
    -- private_ -> (removed)
    -- executable_ -> (removed)
    local real_name = filename
      :gsub("^dot_", ".")
      :gsub("^private_dot_", ".")
      :gsub("^private_", "")
      :gsub("^executable_", "")

    -- Detect the base file type from the real filename
    -- Shell files
    if real_name:match("^%.zsh") or real_name:match("^%.bash") or
       real_name:match("%.zsh%.tmpl$") or real_name:match("%.sh%.tmpl$") or
       real_name:match("%.bash%.tmpl$") then
      vim.bo.filetype = "sh.gotmpl"
    -- Lua files
    elseif real_name:match("%.lua%.tmpl$") then
      vim.bo.filetype = "lua.gotmpl"
    -- YAML files
    elseif real_name:match("%.ya?ml%.tmpl$") then
      vim.bo.filetype = "yaml.gotmpl"
    -- TOML files
    elseif real_name:match("%.toml%.tmpl$") then
      vim.bo.filetype = "toml.gotmpl"
    -- JSON files
    elseif real_name:match("%.json%.tmpl$") then
      vim.bo.filetype = "json.gotmpl"
    -- Config files (.conf, .config)
    elseif real_name:match("%.conf%.tmpl$") or real_name:match("%.config%.tmpl$") then
      vim.bo.filetype = "conf.gotmpl"
    -- Git config
    elseif real_name:match("^%.gitconfig") or real_name:match("gitconfig%.tmpl$") then
      vim.bo.filetype = "gitconfig.gotmpl"
    -- Default to gotmpl (Go template)
    else
      vim.bo.filetype = "gotmpl"
    end
  end,
})
