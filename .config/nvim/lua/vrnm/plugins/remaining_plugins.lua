return {
	-- LSP
	"neovim/nvim-lspconfig", -- enable LSP
	"williamboman/mason.nvim", -- simple to use language server installer
	"williamboman/mason-lspconfig.nvim", -- simple to use language server installer
	"tamago324/nlsp-settings.nvim", -- language server settings defined in json for
	"nvimtools/none-ls.nvim", -- for formatters and linters

	-- You can specify multiple plugins in a single call
	{ "tjdevries/colorbuddy.vim" },

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
	"chrisbra/NrrwRgn",

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
	-- { "mg979/vim-visual-multi", branch = "master" },

	"hlucco/nvim-eswpoch",
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").set_default_keymaps()
		end,
	},
	"eandrju/cellular-automaton.nvim",
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"Wansmer/treesj",
		-- keys = { "<space>tm", "<space>tj", "<space>ts" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({ use_default_keymaps = false })
		end,
	},
	{ "dhruvasagar/vim-table-mode" },
	{ "jbyuki/venn.nvim" },
	-- {
	-- 	"nvim-java/nvim-java",
	-- 	dependencies = {
	-- 		"nvim-java/lua-async-await",
	-- 		"nvim-java/nvim-java-core",
	-- 		"nvim-java/nvim-java-test",
	-- 		"nvim-java/nvim-java-dap",
	-- 		"MunifTanjim/nui.nvim",
	-- 		"neovim/nvim-lspconfig",
	-- 		"mfussenegger/nvim-dap",
	-- 		{
	-- 			"williamboman/mason.nvim",
	-- 			opts = {
	-- 				registries = {
	-- 					"github:nvim-java/mason-registry",
	-- 					"github:mason-org/mason-registry",
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
}
