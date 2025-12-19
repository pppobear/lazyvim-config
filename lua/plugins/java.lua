-- Configure jdtls to use Java 21 (required by jdtls)
-- while keeping Java 8 as the project runtime
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function()
      local java21_home = vim.fn.expand("~/.sdkman/candidates/java/21.0.9-zulu")
      local java8_home = vim.fn.expand("~/.sdkman/candidates/java/8.0.472-zulu")
      local mason_path = vim.fn.stdpath("data") .. "/mason"

      -- Build the cmd with JAVA_HOME set inline
      local cmd = {
        "env",
        "JAVA_HOME=" .. java21_home,
        vim.fn.exepath("jdtls"),
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
            vim.list_extend(full, {
              "-configuration",
              opts.jdtls_config_dir(project_name),
              "-data",
              opts.jdtls_workspace_dir(project_name),
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
