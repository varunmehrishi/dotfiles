return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = {
			enabled = true,
			default_prompt = "Input:",
			border = "rounded",
			relative = "cursor",
		},
		select = {
			enabled = true,
			backend = { "telescope", "builtin" },
			telescope = require("telescope.themes").get_dropdown(),
		},
	},
}
