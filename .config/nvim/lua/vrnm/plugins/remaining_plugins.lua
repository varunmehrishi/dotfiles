return {
  -- LSP
  "neovim/nvim-lspconfig", -- enable LSP
  "williamboman/mason.nvim", -- simple to use language server installer
  "williamboman/mason-lspconfig.nvim", -- simple to use language server installer

  -- Modern formatting and linting (replaces null-ls)
  "stevearc/conform.nvim", -- modern formatter
  "mfussenegger/nvim-lint", -- modern linter

  -- Utilities
  { "tjdevries/colorbuddy.vim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- File icons (used by many plugins)

  { "mechatroner/rainbow_csv", ft = { "csv", "tsv", "rainbow_csv" } },
  { "tommcdo/vim-exchange", event = "VeryLazy" },

  -- tpope plugins
  { "tpope/vim-abolish", cmd = { "Abolish", "Subvert" } },
  { "tpope/vim-eunuch", cmd = { "Delete", "Move", "Rename", "SudoWrite" } },
  { "tpope/vim-fugitive", cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite" } },
  { "tpope/vim-jdaddy", ft = "json" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-speeddating", event = "VeryLazy" },
  { "tpope/vim-surround", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" },

  -- Sorting
  { "vim-scripts/AdvancedSorters", event = "VeryLazy" },
  { "chrisbra/NrrwRgn", cmd = { "NarrowRegion", "NR", "NW" } },

  -- Text Objects
  { "kana/vim-textobj-entire", event = "VeryLazy", dependencies = { "kana/vim-textobj-user" } },
  { "wellle/targets.vim", event = "VeryLazy" },

  -- Telescope with extensions
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "debugloop/telescope-undo.nvim",
    },
    config = function()
      require("vrnm.telescope")
    end,
  },

  -- Fun
  { "eandrju/cellular-automaton.nvim", cmd = "CellularAutomaton" },

  -- Drawing and tables
  { "dhruvasagar/vim-table-mode", cmd = { "TableModeEnable", "TableModeToggle" } },
  { "jbyuki/venn.nvim", cmd = "VBox" },
}
