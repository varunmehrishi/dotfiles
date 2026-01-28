return {
  "folke/which-key.nvim",
  keys = { "<leader>", '"', "'", "`", "c", "v", "g" },
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = false,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    win = {
      border = "rounded",
      padding = { 2, 2, 2, 2 },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    show_help = true,
    -- Fixed: triggers must be a table
    triggers = { "<leader>" }, -- Using a table with just the leader key
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add({
      { "<leader>c", group = "code" },
      { "<leader>d", group = "diagnostics" },
      { "<leader>f", group = "find/file" },
      { "<leader>g", group = "git" },
      { "<leader>l", group = "lsp" },
      { "<leader>m", group = "format" },
      { "<leader>r", group = "rust/rename" },
      { "<leader>s", group = "search" },
      { "<leader>t", group = "telescope" },
      { "<leader>v", group = "venn/vim" },
      { "<leader>w", group = "workspace" },
      { "<leader>y", group = "yank" },
    })
  end,
}
