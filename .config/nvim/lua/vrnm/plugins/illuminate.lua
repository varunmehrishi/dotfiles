return {
	"RRethy/vim-illuminate",
	event = "BufReadPost",
	opts = {
		delay = 200,
		min_count_to_highlight = 2,
		large_file_cutoff = 2000,
		large_file_overrides = {
			providers = { "lsp" },
		},
		filetypes_denylist = {
			"dirbuf",
			"dirvish",
			"fugitive",
			"oil",
			"TelescopePrompt",
		},
	},
	config = function(_, opts)
		require("illuminate").configure(opts)

		-- Keymaps to navigate between references
		vim.keymap.set("n", "]]", function()
			require("illuminate").goto_next_reference(false)
		end, { desc = "Next reference" })
		vim.keymap.set("n", "[[", function()
			require("illuminate").goto_prev_reference(false)
		end, { desc = "Prev reference" })
	end,
}
