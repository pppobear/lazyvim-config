local function clear_stale_plugin_luac()
  local uv = vim.uv or vim.loop
  local cache_root = vim.fn.stdpath("cache") .. "/luac"
  local cache_stat = uv.fs_stat(cache_root)
  if not cache_stat or cache_stat.type ~= "directory" then
    return
  end

  local targets = {
    "/lazy/avante.nvim/",
    "/lazy/render-markdown.nvim/",
  }

  local function is_target(source)
    for _, needle in ipairs(targets) do
      if source:find(needle, 1, true) then
        return true
      end
    end
    return false
  end

  local function is_stale(source, cache_file)
    local source_stat = uv.fs_stat(source)
    local bytecode_stat = uv.fs_stat(cache_file)
    if not source_stat or not bytecode_stat then
      return false
    end
    if source_stat.mtime.sec ~= bytecode_stat.mtime.sec then
      return source_stat.mtime.sec > bytecode_stat.mtime.sec
    end
    return source_stat.mtime.nsec > bytecode_stat.mtime.nsec
  end

  local reset = false
  for name, kind in vim.fs.dir(cache_root) do
    if kind == "file" and name:sub(-5) == ".luac" then
      local source = vim.uri_decode(name:sub(1, -2))
      local cache_file = cache_root .. "/" .. name
      if is_target(source) and is_stale(source, cache_file) then
        pcall(uv.fs_unlink, cache_file)
        reset = true
      end
    end
  end

  if reset and vim.loader and vim.loader.reset then
    vim.loader.reset()
  end
end

clear_stale_plugin_luac()

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
