return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      -- Oil will take over directory buffers (e.g. `vim .` or `:e dir/`)
      default_file_explorer = true,

      -- Columns to display in the file explorer
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },

      -- Send deleted files to trash instead of permanently deleting them
      delete_to_trash = true,

      -- View options
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
      },

      -- Floating window config
      float = {
        padding = 2,
        border = "rounded",
      },
    })

    -- Use a different keybinding since <leader>tt is taken
    vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open Oil file explorer" })

    -- Add a floating mode option with a different keybinding
    vim.keymap.set("n", "<leader>E", "<CMD>Oil --float<CR>", { desc = "Open Oil in float mode" })

    -- Standard oil.nvim binding to go up a directory
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })
  end,
}
