return {
  -- LSP
  "neovim/nvim-lspconfig", -- enable LSP
  "williamboman/mason.nvim", -- simple to use language server installer
  "williamboman/mason-lspconfig.nvim", -- simple to use language server installer

  -- Modern formatting and linting (replaces null-ls)
  "stevearc/conform.nvim", -- modern formatter
  "mfussenegger/nvim-lint", -- modern linter

  -- Utilities
  { "tjdevries/colorbuddy.vim" },
  "nvim-tree/nvim-web-devicons", -- File icons (used by many plugins)

  "mechatroner/rainbow_csv",
  "tommcdo/vim-exchange",

  -- tpope plugins
  "tpope/vim-abolish",
  "tpope/vim-eunuch",
  "tpope/vim-fugitive",
  "tpope/vim-jdaddy",
  "tpope/vim-repeat",
  "tpope/vim-speeddating",
  "tpope/vim-surround",
  "tpope/vim-unimpaired",

  -- Sorting
  "vim-scripts/AdvancedSorters",
  "chrisbra/NrrwRgn",

  -- Text Objects
  { "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" } },
  "wellle/targets.vim",

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
  "eandrju/cellular-automaton.nvim",

  -- Drawing and tables
  { "dhruvasagar/vim-table-mode" },
  { "jbyuki/venn.nvim" },
}
