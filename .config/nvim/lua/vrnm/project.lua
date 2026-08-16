local M = {}

local last_run
local run_id = 0

function M.root(bufnr, fallback)
	bufnr = bufnr or 0
	local markers = {
		"Cargo.toml",
		"pyproject.toml",
		"setup.py",
		"package.json",
		".git",
	}
	local root = vim.fs.root(bufnr, markers) or vim.fs.root(vim.uv.cwd(), markers)
	if root or fallback == false then
		return root
	end
	return vim.uv.cwd()
end

local function python_command(root)
	for _, relative_path in ipairs({ ".venv/bin/python", "venv/bin/python" }) do
		local executable = vim.fs.joinpath(root, relative_path)
		if vim.fn.executable(executable) == 1 then
			return executable
		end
	end
	return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python3"
end

local function pytest_command(root, args)
	local python = python_command(root)
	local has_pytest = vim.system({ python, "-c", "import pytest" }, { text = true }):wait().code == 0
	local command
	if has_pytest then
		command = { python, "-m", "pytest" }
	elseif vim.fn.executable("pytest") == 1 then
		command = { vim.fn.exepath("pytest") }
	elseif vim.fn.executable("uvx") == 1 then
		command = { vim.fn.exepath("uvx"), "pytest" }
	else
		vim.notify("pytest is unavailable; install it in the project environment", vim.log.levels.ERROR)
		return nil
	end

	return vim.list_extend(command, args)
end

local function display_command(command)
	return table.concat(vim.tbl_map(vim.fn.shellescape, command), " ")
end

local function package_scripts(root)
	local package_path = vim.fs.joinpath(root, "package.json")
	local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_path), "\n"))
	if not ok or type(decoded.scripts) ~= "table" then
		return {}
	end
	return decoded.scripts
end

function M.run(command, opts)
	opts = opts or {}
	local root = opts.cwd or M.root(0)
	last_run = { command = vim.deepcopy(command), cwd = root }
	run_id = run_id + 1

	vim.cmd("botright new")
	local bufnr = vim.api.nvim_get_current_buf()
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].buflisted = false
	vim.bo[bufnr].swapfile = false
	vim.api.nvim_buf_set_name(bufnr, ("project://%d/%s"):format(run_id, display_command(command)))

	local job_id = vim.fn.jobstart(command, {
		cwd = root,
		term = true,
		on_exit = function(_, code)
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(bufnr) then
					vim.b[bufnr].project_exit_code = code
				end
				vim.notify(
					("%s exited with code %d"):format(command[1], code),
					code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
				)
			end)
		end,
	})

	if job_id <= 0 then
		vim.notify("Could not start: " .. display_command(command), vim.log.levels.ERROR)
		return
	end
	vim.cmd("startinsert")
end

local function rust_file_test_command(path, root)
	local relative = vim.fs.relpath(root, path) or path
	local integration = relative:match("^tests/([^/]+)%.rs$")
	if integration then
		return { "cargo", "test", "--test", integration, "--", "--nocapture" }
	end

	local binary = relative:match("^src/bin/([^/]+)%.rs$")
	if binary then
		return { "cargo", "test", "--bin", binary, "--", "--nocapture" }
	end

	if relative == "src/lib.rs" then
		return { "cargo", "test", "--lib", "--", "--nocapture" }
	end
	return { "cargo", "test", "--", "--nocapture" }
end

local function nearest_test_name(filetype)
	local cursor = vim.api.nvim_win_get_cursor(0)
	local pattern
	if filetype == "rust" then
		local attribute_pattern = [=[^\s*#\[.*test.*\]]=]
		vim.api.nvim_win_set_cursor(0, { cursor[1], #vim.fn.getline(cursor[1]) })
		local attribute_line = vim.fn.search(attribute_pattern, "bnWc")
		if attribute_line > 0 then
			pattern = [[^\s*\%(async\s\+\)\?fn\s\+\zs[A-Za-z0-9_]\+]]
			for line = attribute_line + 1, math.min(attribute_line + 4, vim.api.nvim_buf_line_count(0)) do
				local name = vim.fn.matchstr(vim.fn.getline(line), pattern)
				if name ~= "" then
					vim.api.nvim_win_set_cursor(0, cursor)
					return name
				end
			end
		end
		vim.api.nvim_win_set_cursor(0, cursor)
		return nil
	elseif filetype == "python" then
		pattern = [[^\s*\%(async\s\+\)\?def\s\+\zstest_[A-Za-z0-9_]\+]]
	end
	if not pattern then
		return nil
	end

	-- Search from the end of the current line so the function declaration is
	-- found even when the cursor is sitting in its indentation.
	vim.api.nvim_win_set_cursor(0, { cursor[1], #vim.fn.getline(cursor[1]) })
	local line = vim.fn.search(pattern, "bnWc")
	local name = line > 0 and vim.fn.matchstr(vim.fn.getline(line), pattern) or nil
	vim.api.nvim_win_set_cursor(0, cursor)
	return name ~= "" and name or nil
end

function M.run_current_file()
	local filetype = vim.bo.filetype
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		vim.notify("Save the buffer before running it", vim.log.levels.WARN)
		return
	end
	vim.cmd("silent write")

	if filetype == "rust" then
		M.run({ "cargo", "run" })
	elseif filetype == "python" then
		local root = M.root(0)
		M.run({ python_command(root), path }, { cwd = root })
	elseif filetype == "javascript" then
		M.run({ "node", path })
	else
		vim.notify("Run-current-file is configured for Rust, Python, and JavaScript", vim.log.levels.WARN)
	end
end

function M.test_nearest()
	local filetype = vim.bo.filetype
	local name = nearest_test_name(filetype)
	if not name then
		vim.notify("No enclosing test function found", vim.log.levels.WARN)
		return
	end
	vim.cmd("silent write")

	if filetype == "rust" then
		M.run({ "cargo", "test", name, "--", "--nocapture" })
	elseif filetype == "python" then
		local root = M.root(0)
		local path = vim.api.nvim_buf_get_name(0)
		local command = pytest_command(root, { path .. "::" .. name, "-q" })
		if command then
			M.run(command, { cwd = root })
		end
	end
end

function M.test_file()
	local filetype = vim.bo.filetype
	local root = M.root(0)
	local path = vim.api.nvim_buf_get_name(0)
	vim.cmd("silent write")

	if filetype == "rust" then
		M.run(rust_file_test_command(path, root), { cwd = root })
	elseif filetype == "python" then
		local command = pytest_command(root, { path, "-q" })
		if command then
			M.run(command, { cwd = root })
		end
	elseif vim.uv.fs_stat(vim.fs.joinpath(root, "package.json")) then
		if package_scripts(root).test then
			M.run({ "npm", "test" }, { cwd = root })
		else
			vim.notify("package.json does not define a test script", vim.log.levels.WARN)
		end
	else
		vim.notify("File tests are configured for Rust and Python", vim.log.levels.WARN)
	end
end

function M.test_all()
	local root = M.root(0)
	if vim.uv.fs_stat(vim.fs.joinpath(root, "Cargo.toml")) then
		M.run({ "cargo", "test", "--", "--nocapture" }, { cwd = root })
	elseif
		vim.uv.fs_stat(vim.fs.joinpath(root, "pyproject.toml")) or vim.uv.fs_stat(vim.fs.joinpath(root, "setup.py"))
	then
		local command = pytest_command(root, { "-q" })
		if command then
			M.run(command, { cwd = root })
		end
	elseif vim.uv.fs_stat(vim.fs.joinpath(root, "package.json")) then
		if package_scripts(root).test then
			M.run({ "npm", "test" }, { cwd = root })
		else
			vim.notify("package.json does not define a test script", vim.log.levels.WARN)
		end
	else
		vim.notify("No supported test project found", vim.log.levels.WARN)
	end
end

function M.run_last()
	if not last_run then
		vim.notify("No project command has run yet", vim.log.levels.INFO)
		return
	end
	M.run(last_run.command, { cwd = last_run.cwd })
end

function M.choose_task()
	local root = M.root(0)
	local choices
	if vim.uv.fs_stat(vim.fs.joinpath(root, "Cargo.toml")) then
		choices = {
			{ label = "build", command = { "cargo", "build" } },
			{ label = "check", command = { "cargo", "check" } },
			{ label = "clippy", command = { "cargo", "clippy", "--all-targets", "--all-features" } },
			{ label = "run", command = { "cargo", "run" } },
			{ label = "test all", command = { "cargo", "test", "--", "--nocapture" } },
		}
	elseif
		vim.uv.fs_stat(vim.fs.joinpath(root, "pyproject.toml")) or vim.uv.fs_stat(vim.fs.joinpath(root, "setup.py"))
	then
		local python = python_command(root)
		local pytest = pytest_command(root, { "-q" })
		choices = {
			{ label = "compile", command = { python, "-m", "compileall", "-q", "." } },
			{ label = "flake8", command = { "flake8", "." } },
		}
		if pytest then
			table.insert(choices, 1, { label = "pytest", command = pytest })
		end
	elseif vim.uv.fs_stat(vim.fs.joinpath(root, "package.json")) then
		choices = {}
		for name in pairs(package_scripts(root)) do
			table.insert(choices, { label = "npm run " .. name, command = { "npm", "run", name } })
		end
		table.sort(choices, function(left, right)
			return left.label < right.label
		end)
		if #choices == 0 then
			vim.notify("package.json does not define any scripts", vim.log.levels.WARN)
			return
		end
	else
		vim.notify("No Rust, Python, or npm project found", vim.log.levels.WARN)
		return
	end

	vim.ui.select(choices, {
		prompt = "Project task",
		format_item = function(item)
			return item.label
		end,
	}, function(choice)
		if choice then
			M.run(choice.command, { cwd = root })
		end
	end)
end

vim.api.nvim_create_user_command("ProjectTask", M.choose_task, { desc = "Choose a project task" })
vim.api.nvim_create_user_command("TestNearest", M.test_nearest, { desc = "Run the nearest test" })
vim.api.nvim_create_user_command("TestFile", M.test_file, { desc = "Run tests for the current file" })
vim.api.nvim_create_user_command("TestAll", M.test_all, { desc = "Run all project tests" })
vim.api.nvim_create_user_command("TestLast", M.run_last, { desc = "Repeat the last project command" })

vim.keymap.set("n", "<leader>xx", M.run_current_file, { desc = "Run current file" })
vim.keymap.set("n", "<leader>xn", M.test_nearest, { desc = "Test nearest" })
vim.keymap.set("n", "<leader>xf", M.test_file, { desc = "Test file" })
vim.keymap.set("n", "<leader>xa", M.test_all, { desc = "Test all" })
vim.keymap.set("n", "<leader>xl", M.run_last, { desc = "Run last task" })
vim.keymap.set("n", "<leader>xc", M.choose_task, { desc = "Choose project task" })

return M
