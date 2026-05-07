vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	callback = function()
		vim.hl.on_yank()
	end,
})

local bigfile_group = vim.api.nvim_create_augroup("vrnm_bigfile", { clear = true })
local BIGFILE_SIZE = 1.5 * 1024 * 1024

vim.api.nvim_create_autocmd("BufReadPre", {
	group = bigfile_group,
	desc = "Detect big files and disable expensive options",
	callback = function(args)
		local ok, stat = pcall(vim.uv.fs_stat, args.file)
		if not ok or not stat or stat.size <= BIGFILE_SIZE then
			return
		end
		vim.b[args.buf].bigfile = true
		vim.b[args.buf].gitsigns_disable = true
		vim.bo[args.buf].swapfile = false
		vim.bo[args.buf].undolevels = -1
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = bigfile_group,
	desc = "Stop treesitter on big files and notify",
	callback = function(args)
		if not vim.b[args.buf].bigfile then
			return
		end
		pcall(vim.treesitter.stop, args.buf)
		local size = (vim.uv.fs_stat(args.file) or { size = 0 }).size
		vim.notify(
			("bigfile mode: LSP/treesitter/gitsigns disabled (%.1f MB)"):format(size / 1024 / 1024),
			vim.log.levels.INFO
		)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = bigfile_group,
	desc = "Detach LSP from big files",
	callback = function(args)
		if not vim.b[args.buf].bigfile then
			return
		end
		vim.schedule(function()
			vim.lsp.buf_detach_client(args.buf, args.data.client_id)
		end)
	end,
})
