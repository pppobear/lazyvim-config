-- Configure jdtls to use Java 21 (required by jdtls)
-- while keeping Java 8 as the project runtime
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function()
      local java21_home = vim.fn.expand("~/.asdf/installs/java/zulu-21.46.19/zulu-21.jdk/Contents/Home")
      local java8_home = vim.fn.expand("~/.asdf/installs/java/zulu-8.90.0.19/zulu-8.jdk/Contents/Home")
      local mason_path = vim.fn.stdpath("data") .. "/mason"

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
              runtimes = {
                {
                  name = "JavaSE-1.8",
                  path = java8_home,
                  default = true,
                },
                {
                  name = "JavaSE-21",
                  path = java21_home,
                },
              },
            },
          },
        },
      }
    end,
  },
}
