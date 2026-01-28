return {
	-- LSP
	"neovim/nvim-lspconfig", -- enable LSP
	"williamboman/mason.nvim", -- simple to use language server installer
	"williamboman/mason-lspconfig.nvim", -- simple to use language server installer
	-- Modern formatting and linting (replaces null-ls)
	"stevearc/conform.nvim", -- modern formatter
	"mfussenegger/nvim-lint", -- modern linter

	-- You can specify multiple plugins in a single call
	{ "tjdevries/colorbuddy.vim" },
	"nvim-tree/nvim-web-devicons", -- File icons (used by many plugins)
	{
		"inkarkat/vim-mark",
		dependencies = { "inkarkat/vim-ingo-library" },
		init = function()
			-- Disable all default mappings
			vim.g.mw_no_mappings = 1
		end,
		config = function()
			-- Only set up <leader>m for marking
			vim.keymap.set("n", "<leader>m", "<Plug>MarkSet", { desc = "Mark word" })
			vim.keymap.set("x", "<leader>m", "<Plug>MarkSet", { desc = "Mark selection" })
			vim.keymap.set("n", "<leader>M", "<Plug>MarkClear", { desc = "Clear mark" })
			vim.keymap.set("n", "<leader>n", "<Plug>MarkSearchNext", { desc = "Next mark" })
			vim.keymap.set("n", "<leader>N", "<Plug>MarkSearchPrev", { desc = "Prev mark" })
		end,
	},

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
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("vrnm.telescope")
		end,
	},
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

	-- Modern Telescope enhancements
	{ "debugloop/telescope-undo.nvim" },
	{
		url = "https://codeberg.org/andyg/leap.nvim",
		config = function()
			-- Manual mappings (recommended approach)
			vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
			vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
			vim.keymap.set({'o'}, 'x',  '<Plug>(leap-forward-till)')
			vim.keymap.set({'o'}, 'X',  '<Plug>(leap-backward-till)')
			vim.keymap.set({'n', 'x', 'o'}, 'gS', '<Plug>(leap-from-window)')
		end,
	},
	"eandrju/cellular-automaton.nvim",
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({ use_default_keymaps = false })
		end,
	},
	{ "dhruvasagar/vim-table-mode" },
	{ "jbyuki/venn.nvim" },
}
