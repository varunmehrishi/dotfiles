return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({ options = { theme = "dracula" } })
	end,
	dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
}
