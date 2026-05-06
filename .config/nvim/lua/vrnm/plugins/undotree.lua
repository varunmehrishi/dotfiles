return {
	"mbbill/undotree",
	keys = {
		{ "<leader>U", "<cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
	},
	config = function()
		vim.g.undotree_SetFocusWhenToggle = 1
	end,
}
