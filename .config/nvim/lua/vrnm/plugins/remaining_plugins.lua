return {
	-- LSP
	"neovim/nvim-lspconfig", -- enable LSP
	"williamboman/mason.nvim", -- simple to use language server installer
	"williamboman/mason-lspconfig.nvim", -- simple to use language server installer
	-- Removed: "tamago324/nlsp-settings.nvim" (deprecated)

	-- Modern formatting and linting (replaces null-ls)
	"stevearc/conform.nvim", -- modern formatter
	"mfussenegger/nvim-lint", -- modern linter

	-- You can specify multiple plugins in a single call
	{ "tjdevries/colorbuddy.vim" },
	"nvim-tree/nvim-web-devicons", -- File icons (used by many plugins)

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

	-- Sort Lines (modern alternative)
	"vim-scripts/AdvancedSorters", -- Keep for compatibility
	"chrisbra/NrrwRgn",

	-- Modern sorting alternative
	{
		"sQVe/sort.nvim",
		config = function()
			require("sort").setup()
		end,
	},

	-- Test Objects
	{ "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" } },
	"wellle/targets.vim",

	-- Telescope
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

	-- Modern Telescope enhancements
	{ "debugloop/telescope-undo.nvim" }, -- Undo history in Telescope
	-- multiple cursors
	--
	-- { "mg979/vim-visual-multi", branch = "master" },

	"hlucco/nvim-eswpoch",
	{
		"ggandor/leap.nvim",
		config = function()
			-- Manual mappings (recommended approach)
			vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
			vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
			vim.keymap.set({'x', 'o'}, 'x',  '<Plug>(leap-forward-till)')
			vim.keymap.set({'x', 'o'}, 'X',  '<Plug>(leap-backward-till)')
			vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')
		end,
	},
	"eandrju/cellular-automaton.nvim",
	-- Neo-tree removed and replaced with oil.nvim
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
