local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	-- Post-install/update hook with neovim command
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	-- Post-install/update hook with call of vimscript function with argument
	{
		"glacambre/firenvim",
		build = function()
			vim.fn["firenvim#install"](0)
		end,
	},

	-- Use dependency and run lua function after load
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup()
		end,
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	{ "junegunn/fzf", build = ":call fzf#install()" },
	"junegunn/fzf.vim",

	-- cmp plugins
	"hrsh7th/nvim-cmp", -- The completion plugin
	"hrsh7th/cmp-buffer", -- buffer completions
	"hrsh7th/cmp-path", -- path completions
	"hrsh7th/cmp-cmdline", -- cmdline completions
	"hrsh7th/cmp-nvim-lsp",
	"saadparwaiz1/cmp_luasnip", -- snippet completions

	-- snippets
	"L3MON4D3/LuaSnip", --snippet engine
	"rafamadriz/friendly-snippets", -- a bunch of snippets to use
	"simrat39/rust-tools.nvim",

	-- LSP
	"neovim/nvim-lspconfig", -- enable LSP
	"williamboman/mason.nvim", -- simple to use language server installer
	"williamboman/mason-lspconfig.nvim", -- simple to use language server installer
	"tamago324/nlsp-settings.nvim", -- language server settings defined in json for
	"jose-elias-alvarez/null-ls.nvim", -- for formatters and linters

	-- You can specify multiple plugins in a single call
	{ "tjdevries/colorbuddy.vim" },

	-- You can alias plugin names
	{
		"dracula/vim",
		name = "dracula",
		config = function()
			vim.cmd([[colorscheme dracula]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({ options = { theme = "dracula" } })
		end,
		dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
	},

	{
		"j-hui/fidget.nvim",
    tag = 'legacy',
		config = function()
			require("fidget").setup()
		end,
	},

	"RRethy/vim-illuminate", -- illuminate word under cursor for lsp enabled buffers
	"inkarkat/vim-ingo-library",
	"inkarkat/vim-mark",

	"mechatroner/rainbow_csv",

	-- "thinca/vim-visualstar",
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

	-- Sort Lines
	"vim-scripts/AdvancedSorters",

	-- Test Objects
	{ "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" } },
	"wellle/targets.vim",

	-- Telescope
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	-- multiple cursors
	--
	{ "mg979/vim-visual-multi", branch = "master" },

	"hlucco/nvim-eswpoch",
	{
		"mbbill/undotree",
		config = function()
			vim.cmd([[
                if !exists('g:undotree_SetFocusWhenToggle')
                    let g:undotree_SetFocusWhenToggle = 1
                endif
      ]])
		end,
	},
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").set_default_keymaps()
		end,
	},
	"eandrju/cellular-automaton.nvim",
}

require("lazy").setup(plugins, {})
