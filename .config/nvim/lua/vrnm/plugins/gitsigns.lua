return {
	"lewis6991/gitsigns.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim", -- Add telescope as a dependency
	},
	config = function()
		require("vrnm.gitsigns") -- Load your gitsigns configuration
	end,
}
