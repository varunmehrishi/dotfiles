local ok, dap = pcall(require, "dap")
if not ok then
	return
end

local mason_root = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages")
local debugpy_python = vim.fs.joinpath(mason_root, "debugpy", "venv", "bin", "python")

dap.adapters.python = {
	type = "executable",
	command = debugpy_python,
	args = { "-m", "debugpy.adapter" },
}

local function project_python()
	local root = vim.fs.root(0, { "pyproject.toml", "setup.py", "requirements.txt", ".git" })
	if root then
		for _, relative_path in ipairs({ ".venv/bin/python", "venv/bin/python" }) do
			local executable = vim.fs.joinpath(root, relative_path)
			if vim.fn.executable(executable) == 1 then
				return executable
			end
		end
	end

	if vim.env.VIRTUAL_ENV then
		local executable = vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
		if vim.fn.executable(executable) == 1 then
			return executable
		end
	end

	return vim.fn.exepath("python3")
end

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Debug current file",
		program = "${file}",
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
		pythonPath = project_python,
	},
	{
		type = "python",
		request = "launch",
		name = "Debug current test with pytest",
		module = "pytest",
		args = function()
			return { vim.fn.expand("%:p") }
		end,
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
		pythonPath = project_python,
	},
}

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })

local mappings = {
	{ "<F5>", dap.continue, "Debug: start/continue" },
	{ "<F10>", dap.step_over, "Debug: step over" },
	{ "<F11>", dap.step_into, "Debug: step into" },
	{ "<F12>", dap.step_out, "Debug: step out" },
	{ "<leader>Db", dap.toggle_breakpoint, "Toggle breakpoint" },
	{
		"<leader>DB",
		function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end,
		"Conditional breakpoint",
	},
	{ "<leader>Dc", dap.run_to_cursor, "Run to cursor" },
	{ "<leader>Dl", dap.run_last, "Run last debug session" },
	{ "<leader>Dr", dap.repl.toggle, "Toggle debug REPL" },
	{ "<leader>Dt", dap.terminate, "Terminate debug session" },
}

for _, mapping in ipairs(mappings) do
	vim.keymap.set("n", mapping[1], mapping[2], { silent = true, desc = mapping[3] })
end
