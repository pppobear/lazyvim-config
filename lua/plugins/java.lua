local function trim(value)
  return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function java_executable(home)
  return home and home ~= "" and vim.fn.executable(home .. "/bin/java") == 1
end

local function java_major(home)
  if not java_executable(home) then
    return nil
  end

  local output = vim.fn.systemlist({ home .. "/bin/java", "-version" })
  local version = table.concat(output, "\n"):match('version "([^"]+)"')
  if not version then
    return nil
  end

  if version:match("^1%.8") then
    return "8"
  end

  return version:match("^(%d+)")
end

local function system_java_home(version)
  if vim.fn.executable("/usr/libexec/java_home") ~= 1 then
    return nil
  end

  local output = vim.fn.systemlist({ "/usr/libexec/java_home", "-v", version })
  if vim.v.shell_error == 0 and output[1] and java_executable(trim(output[1])) then
    return trim(output[1])
  end

  return nil
end

local function asdf_java_home(major)
  local asdf_dir = vim.env.ASDF_DATA_DIR or vim.fn.expand("~/.asdf")
  local candidates = vim.fn.glob(asdf_dir .. "/installs/java/*/*/Contents/Home", false, true)
  table.sort(candidates)

  for i = #candidates, 1, -1 do
    local home = candidates[i]
    if java_major(home) == major then
      return home
    end
  end

  return nil
end

local function env_java_home(major, names)
  for _, name in ipairs(names) do
    local home = vim.env[name]
    if java_major(home) == major then
      return home
    end
  end

  return nil
end

local function resolve_java_home(major, system_version, env_names)
  return system_java_home(system_version) or env_java_home(major, env_names) or asdf_java_home(major)
end

-- Configure jdtls to use Java 21 (required by jdtls)
-- while keeping Java 8 as the project runtime.
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function()
      local java21_home = resolve_java_home("21", "21", { "JAVA21_HOME", "JAVA_21_HOME", "JAVA_HOME" })
      local java8_home = resolve_java_home("8", "1.8", { "JAVA8_HOME", "JAVA_8_HOME" })
      local mason_path = vim.fn.stdpath("data") .. "/mason"
      local runtimes = {}

      assert(java21_home, "Java 21 home not found. Install/register a JDK 21 or set JAVA21_HOME.")

      if java8_home then
        table.insert(runtimes, {
          name = "JavaSE-1.8",
          path = java8_home,
          default = true,
        })
      else
        vim.notify("Java 8 home not found. Project runtime JavaSE-1.8 was not configured.", vim.log.levels.WARN)
      end

      table.insert(runtimes, {
        name = "JavaSE-21",
        path = java21_home,
      })

      local cmd = {
        mason_path .. "/bin/jdtls",
        "--java-executable",
        java21_home .. "/bin/java",
      }

      -- Add lombok if available
      local lombok_jar = mason_path .. "/share/jdtls/lombok.jar"
      if vim.fn.filereadable(lombok_jar) == 1 then
        table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
      end

      return {
        cmd = cmd,
        -- Required by LazyVim java extra
        root_dir = function(path)
          return vim.fs.root(path, { "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
        end,
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,
        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local full = vim.deepcopy(opts.cmd)
          if project_name then
            local config_dir = opts.jdtls_config_dir(project_name)
            local workspace_dir = opts.jdtls_workspace_dir(project_name)
            vim.fn.mkdir(config_dir, "p")
            vim.fn.mkdir(workspace_dir, "p")
            vim.list_extend(full, {
              "-configuration",
              config_dir,
              "-data",
              workspace_dir,
            })
          end
          return full
        end,
        -- Configure project runtimes - Java 8 for your project builds
        settings = {
          java = {
            configuration = {
              runtimes = runtimes,
            },
          },
        },
      }
    end,
  },
}
