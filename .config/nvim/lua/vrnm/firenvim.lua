local M = {}

local solution_helper = {
	"#![allow(dead_code)]",
	"#[cfg(test)]",
	"struct Solution;",
	"",
}

local function has_solution_helper(lines)
	for index, line in ipairs(solution_helper) do
		if lines[index] ~= line then
			return false
		end
	end

	return true
end

local function write_if_missing(path, lines)
	if vim.uv.fs_stat(path) then
		return
	end

	local ok = vim.fn.writefile(lines, path)
	if ok ~= 0 then
		error("could not create " .. path)
	end
end

local function ensure_rust_project()
	local root = vim.fs.joinpath(vim.fn.stdpath("data"), "firenvim-rust")
	local src_dir = vim.fs.joinpath(root, "src")
	local tests_dir = vim.fs.joinpath(root, "tests")

	vim.fn.mkdir(src_dir, "p")
	vim.fn.mkdir(tests_dir, "p")

	write_if_missing(vim.fs.joinpath(root, "Cargo.toml"), {
		"[package]",
		'name = "firenvim_scratch"',
		'version = "0.1.0"',
		'edition = "2021"',
		"publish = false",
		"",
		"[dependencies]",
	})
	write_if_missing(vim.fs.joinpath(src_dir, "lib.rs"), {
		"// Shared code for temporary Firenvim Rust buffers can go here.",
	})

	return root, tests_dir
end

local function unused_rust_path(tests_dir, bufnr)
	local stem = ("firenvim-%d-%d"):format(vim.fn.getpid(), bufnr)
	local path = vim.fs.joinpath(tests_dir, stem .. ".rs")
	local suffix = 1

	while vim.uv.fs_stat(path) do
		path = vim.fs.joinpath(tests_dir, ("%s-%d.rs"):format(stem, suffix))
		suffix = suffix + 1
	end

	return path
end

local function page_content(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local cursor = vim.api.nvim_win_get_cursor(0)

	if has_solution_helper(lines) then
		local first_content_line = #solution_helper + 1
		lines = vim.list_slice(lines, first_content_line)
		cursor[1] = math.max(1, cursor[1] - first_content_line + 1)
	end

	if #lines == 0 then
		lines = { "" }
	end

	return lines, cursor
end

local function activate_rust()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
		vim.notify(":FRust requires a normal, modifiable buffer", vim.log.levels.ERROR)
		return
	end

	local existing_path = vim.b[bufnr].firenvim_rust_path
	if existing_path then
		vim.notify("This buffer is already using the Firenvim Rust project: " .. existing_path)
		return
	end

	local ok, root_or_error, tests_dir = pcall(ensure_rust_project)
	if not ok then
		vim.notify("Could not prepare the Firenvim Rust project: " .. root_or_error, vim.log.levels.ERROR)
		return
	end

	local root = root_or_error
	local original_path = vim.api.nvim_buf_get_name(bufnr)
	if not vim.g.started_by_firenvim and original_path ~= "" then
		vim.notify(
			":FRust will not replace a named file; use <leader>rf to open a new scratch buffer",
			vim.log.levels.ERROR
		)
		return
	end

	local rust_path = unused_rust_path(tests_dir, bufnr)
	local original_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local original_cursor = vim.api.nvim_win_get_cursor(0)

	if not has_solution_helper(original_lines) then
		vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, solution_helper)
		vim.api.nvim_win_set_cursor(0, { original_cursor[1] + #solution_helper, original_cursor[2] })
	end

	-- rust-analyzer finds Cargo.toml by walking upward from the actual buffer
	-- path, so changing only Neovim's working directory would not be enough.
	vim.api.nvim_buf_set_name(bufnr, rust_path)
	local wrote, write_error = pcall(vim.api.nvim_buf_call, bufnr, function()
		vim.cmd("silent write")
	end)
	if not wrote then
		vim.api.nvim_buf_set_name(bufnr, original_path)
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, original_lines)
		vim.api.nvim_win_set_cursor(0, original_cursor)
		vim.notify("Could not create the Firenvim Rust file: " .. write_error, vim.log.levels.ERROR)
		return
	end

	vim.b[bufnr].firenvim_original_path = original_path
	vim.b[bufnr].firenvim_rust_path = rust_path

	local group = vim.api.nvim_create_augroup("VRNMFirenvimRust" .. bufnr, { clear = true })
	if vim.g.started_by_firenvim then
		vim.api.nvim_create_autocmd("BufWrite", {
			group = group,
			buffer = bufnr,
			desc = "Synchronize the renamed Rust buffer with Firenvim",
			callback = function()
				local lines, cursor = page_content(bufnr)
				vim.fn["firenvim#write"](lines, cursor)
			end,
		})
	end

	local function remove_scratch_file()
		vim.fn.delete(rust_path)
	end

	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		buffer = bufnr,
		once = true,
		callback = remove_scratch_file,
	})
	vim.api.nvim_create_autocmd("VimLeave", {
		group = group,
		once = true,
		callback = remove_scratch_file,
	})

	vim.bo[bufnr].filetype = "rust"
	vim.schedule(function()
		if vim.api.nvim_buf_is_valid(bufnr) then
			require("rustaceanvim.lsp").start(bufnr)
		end
	end)

	vim.notify("Rust Solution scratch project: " .. root)
end

local function open_rust_scratch()
	if not vim.g.started_by_firenvim and vim.api.nvim_buf_get_name(0) ~= "" then
		local bufnr = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_win_set_buf(0, bufnr)
	end

	activate_rust()
end

function M.setup()
	vim.api.nvim_create_user_command("FRust", activate_rust, {
		desc = "Use the current buffer as a Rust Solution Cargo test target",
	})
	vim.keymap.set("n", "<leader>rf", open_rust_scratch, {
		desc = "Open a Rust Solution scratch buffer",
	})
end

return M
