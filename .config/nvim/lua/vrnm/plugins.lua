-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Post-install/update hook with call of vimscript function with argument
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- Use dependency and run lua function after load
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use { 'junegunn/fzf', run = ":call fzf#install()" }
  use 'junegunn/fzf.vim'

  -- cmp plugins
  use 'hrsh7th/nvim-cmp' -- The completion plugin
  use 'hrsh7th/cmp-buffer' -- buffer completions
  use 'hrsh7th/cmp-path' -- path completions
  use 'hrsh7th/cmp-cmdline' -- cmdline completions
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip' -- snippet completions

  -- snippets
  use 'L3MON4D3/LuaSnip' --snippet engine
  use 'rafamadriz/friendly-snippets' -- a bunch of snippets to use
  use 'simrat39/rust-tools.nvim'

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/mason.nvim" -- simple to use language server installer
  use "williamboman/mason-lspconfig.nvim" -- simple to use language server installer
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

  -- You can specify multiple plugins in a single call
  use { 'tjdevries/colorbuddy.vim' }

  -- You can alias plugin names
  use { 'dracula/vim', as = 'dracula', config = function() vim.cmd [[colorscheme dracula]] end }
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({ options = { theme = 'dracula' } })
    end,
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup() end,
  }

  use 'RRethy/vim-illuminate' -- illuminate word under cursor for lsp enabled buffers
  use 'inkarkat/vim-ingo-library'
  use 'inkarkat/vim-mark'

  use 'mechatroner/rainbow_csv'

  use 'thinca/vim-visualstar'
  use 'tommcdo/vim-exchange'

  -- tpope plugins
  use 'tpope/vim-abolish'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-jdaddy'
  use 'tpope/vim-repeat'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'

  -- Sort Lines
  use 'vim-scripts/AdvancedSorters'

  -- Test Objects
  use { 'kana/vim-textobj-entire', requires = { 'kana/vim-textobj-user' } }
  use 'wellle/targets.vim'

  -- Telescope
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use {'nvim-telescope/telescope-ui-select.nvim' }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- multiple cursors
  --
  use { 'mg979/vim-visual-multi', branch = 'master' }

  use 'ojroques/nvim-osc52'
  use 'hlucco/nvim-eswpoch'
end)
