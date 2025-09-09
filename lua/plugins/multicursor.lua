return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- Keymap helper function with description support
      local function map(mode, key, func, desc)
        vim.keymap.set(mode, key, func, { desc = desc, silent = true })
      end

      -- Add or skip adding a new cursor by matching word/selection
      map({ "n", "x" }, "<C-n>", function()
        mc.matchAddCursor(1)
      end, "Add cursor by match (forward)")

      map({ "n", "x" }, "<C-S-p>", function()
        mc.matchSkipCursor(1)
      end, "Skip cursor by match (forward)")

      -- map({ "n", "x" }, "<C-p>", function()
      --   mc.matchAddCursor(-1)
      -- end, "Add cursor by match (backward)")

      map({ "n", "x" }, "<C-p>", function()
        mc.matchSkipCursor(-1)
      end, "Skip cursor by match (backward)")

      -- Add and remove cursors with control + left click
      map("n", "<c-leftmouse>", mc.handleMouse, "Toggle cursor with mouse")
      map("n", "<c-leftdrag>", mc.handleMouseDrag, "Drag cursor with mouse")
      map("n", "<c-leftrelease>", mc.handleMouseRelease, "Release mouse cursor")

      -- Toggle cursors
      map({ "n", "x" }, "<leader>mt", mc.toggleCursor, "Toggle cursor")

      -- Multi-cursor layer keymaps (only active when multiple cursors exist)
      mc.addKeymapLayer(function(layerSet)
        -- Navigate between cursors
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete current cursor
        layerSet({ "n", "x" }, "<leader>md", mc.deleteCursor)

        -- Clear all cursors or enable disabled cursors
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
}
