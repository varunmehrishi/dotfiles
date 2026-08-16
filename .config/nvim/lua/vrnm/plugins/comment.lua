return {
	"numToStr/Comment.nvim",
	event = { "BufReadPost", "BufNewFile", "FileType" },
	config = function()
		require("Comment").setup()
	end,
}
