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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    -- 设置 includeexpr 来转换以 / 开头的路径
    vim.opt_local.includeexpr = "substitute(v:fname, '^/', '', '')"
    -- 或者更精确地只转换 /docs 开头的路径
    -- vim.opt_local.includeexpr = "substitute(v:fname, '^/docs', 'docs', '')"

    -- 设置 suffixesadd 以便自动添加 .md 扩展名（如果需要）
    vim.opt_local.suffixesadd = ".md"
    vim.diagnostic.enable(false, { bufnr = event.buf }) -- 停用该缓冲区的 LSP/诊断
    vim.opt_local.spell = false -- 关闭拼写检查
  end,
})
