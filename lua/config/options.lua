-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.colorcolumn = "0"
vim.opt.cursorlineopt = "number"
vim.opt.textwidth = 80
vim.opt.whichwrap = "<,>,[,]"
vim.opt.numberwidth = 4
vim.opt.pumwidth = 80

-- Neovide: modern, polished GUI defaults.
-- Keep terminal Neovim untouched and only apply when running inside Neovide.
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h15"
  vim.o.linespace = 2
  vim.o.termguicolors = true

  -- Slightly translucent window with macOS blur gives Neovide a lighter,
  -- native-feeling surface while preserving editor readability.
  vim.g.neovide_opacity = 0.94
  vim.g.neovide_normal_opacity = 0.94
  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  -- Breathing room around the editor content.
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_right = 12
  vim.g.neovide_padding_left = 12

  -- Smooth, modern motion without being distracting.
  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_scroll_animation_length = 0.18
  vim.g.neovide_cursor_animation_length = 0.08
  vim.g.neovide_cursor_trail_size = 0.35
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true

  -- Subtle cursor effect; set to "" if you prefer a fully static cursor.
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_particle_lifetime = 0.7
  vim.g.neovide_cursor_vfx_particle_density = 7.0
  vim.g.neovide_cursor_vfx_particle_speed = 10.0

  -- GUI niceties.
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_macos_option_key_is_meta = "only_left"
end

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
