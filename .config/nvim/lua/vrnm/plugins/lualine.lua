return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				theme = "dracula",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true, -- Use global statusline
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } }, -- Show relative path
				lualine_x = { "snacks" }, -- Add snacks component here
				lualine_y = { "encoding", "fileformat", "filetype" },
				lualine_z = { "progress", "location" },
			},
			extensions = { "oil", "fugitive" },
		})
	end,
	dependencies = {
		"kyazdani42/nvim-web-devicons",
		"folke/snacks.nvim", -- Add snacks as a dependency
	},
}
