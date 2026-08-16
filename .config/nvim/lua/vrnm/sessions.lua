local M = {}

local project = require("vrnm.project")
local session_dir = vim.fs.joinpath(vim.fn.stdpath("state"), "sessions")

local function paths(root)
	local id = vim.fn.sha256(root):sub(1, 16)
	return vim.fs.joinpath(session_dir, id .. ".vim"), vim.fs.joinpath(session_dir, id .. ".root")
end

local function modified_buffers()
	return vim.tbl_filter(function(bufnr)
		return vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modified
	end, vim.api.nvim_list_bufs())
end

function M.save(opts)
	opts = opts or {}
	if vim.g.started_by_firenvim or #vim.api.nvim_list_uis() == 0 then
		return
	end
	local root = project.root(0, false)
	if not root then
		if not opts.silent then
			vim.notify("No project root found; session not saved", vim.log.levels.INFO)
		end
		return
	end

	vim.fn.mkdir(session_dir, "p")
	local session_path, root_path = paths(root)
	vim.cmd("silent! mksession! " .. vim.fn.fnameescape(session_path))
	vim.fn.writefile({ root }, root_path)
	if not opts.silent then
		vim.notify("Session saved for " .. root)
	end
end

function M.load(root, opts)
	opts = opts or {}
	root = root or project.root(0, false)
	if not root then
		if not opts.silent then
			vim.notify("No project root found", vim.log.levels.INFO)
		end
		return false
	end

	local session_path = paths(root)
	if not vim.uv.fs_stat(session_path) then
		if not opts.silent then
			vim.notify("No saved session for " .. root, vim.log.levels.INFO)
		end
		return false
	end
	if #modified_buffers() > 0 then
		vim.notify("Save or discard modified buffers before loading a session", vim.log.levels.WARN)
		return false
	end

	vim.cmd("silent source " .. vim.fn.fnameescape(session_path))
	if not opts.silent then
		vim.notify("Session loaded for " .. root)
	end
	return true
end

function M.delete()
	local root = project.root(0, false)
	if not root then
		vim.notify("No project root found", vim.log.levels.INFO)
		return
	end
	local session_path, root_path = paths(root)
	vim.fn.delete(session_path)
	vim.fn.delete(root_path)
	vim.notify("Session deleted for " .. root)
end

function M.switch()
	if not vim.uv.fs_stat(session_dir) then
		vim.notify("No saved sessions", vim.log.levels.INFO)
		return
	end

	local roots = {}
	for name, kind in vim.fs.dir(session_dir) do
		if kind == "file" and name:sub(-5) == ".root" then
			local lines = vim.fn.readfile(vim.fs.joinpath(session_dir, name), "", 1)
			if lines[1] and vim.uv.fs_stat(lines[1]) then
				table.insert(roots, lines[1])
			end
		end
	end
	table.sort(roots)

	vim.ui.select(roots, { prompt = "Saved project session" }, function(root)
		if root then
			M.load(root)
		end
	end)
end

vim.opt.sessionoptions = {
	"buffers",
	"curdir",
	"folds",
	"help",
	"tabpages",
	"winsize",
}

vim.api.nvim_create_user_command("SessionSave", M.save, { desc = "Save the current project session" })
vim.api.nvim_create_user_command("SessionLoad", function()
	M.load()
end, { desc = "Load the current project session" })
vim.api.nvim_create_user_command("SessionDelete", M.delete, { desc = "Delete the current project session" })
vim.api.nvim_create_user_command("SessionSwitch", M.switch, { desc = "Switch to a saved project session" })

vim.keymap.set("n", "<leader>ws", M.save, { desc = "Save project session" })
vim.keymap.set("n", "<leader>wo", function()
	M.load()
end, { desc = "Load project session" })
vim.keymap.set("n", "<leader>wp", M.switch, { desc = "Switch project session" })

local group = vim.api.nvim_create_augroup("VRNMSessions", { clear = true })
vim.api.nvim_create_autocmd("VimLeavePre", {
	group = group,
	callback = function()
		M.save({ silent = true })
	end,
})
vim.api.nvim_create_autocmd("VimEnter", {
	group = group,
	once = true,
	callback = function()
		if vim.fn.argc() == 0 and not vim.g.started_by_firenvim and #vim.api.nvim_list_uis() > 0 then
			M.load(nil, { silent = true })
		end
	end,
})

return M
