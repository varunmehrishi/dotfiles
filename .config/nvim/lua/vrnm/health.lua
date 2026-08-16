local M = {}

local function check(lines, label, ok, detail)
	local icon = ok == nil and "•" or (ok and "✓" or "✗")
	table.insert(lines, ("%s %-24s %s"):format(icon, label, detail or ""))
end

local function executable(lines, label, command)
	local path = vim.fn.exepath(command)
	check(lines, label, path ~= "", path ~= "" and path or (command .. " not found"))
end

function M.show()
	local lines = {
		"Neovim configuration health",
		string.rep("=", 28),
		"",
	}

	check(lines, "Neovim", vim.fn.has("nvim-0.11") == 1, vim.version().major .. "." .. vim.version().minor)
	executable(lines, "Rust analyzer", "rust-analyzer")
	executable(lines, "Rust formatter", "rustfmt")
	executable(lines, "Python LSP", "pyright-langserver")
	executable(lines, "Python", "python3")
	executable(lines, "Python formatter", "black")
	executable(lines, "Python linter", "flake8")
	local pytest_runner = vim.fn.exepath("pytest")
	if pytest_runner == "" then
		pytest_runner = vim.fn.exepath("uvx")
	end
	check(
		lines,
		"Python test runner",
		pytest_runner ~= "",
		pytest_runner ~= "" and pytest_runner or "pytest/uvx not found"
	)
	executable(lines, "Prettier", "prettier")
	executable(lines, "ESLint daemon", "eslint_d")

	local data = vim.fn.stdpath("data")
	local codelldb = vim.fs.joinpath(data, "mason", "packages", "codelldb", "extension", "adapter", "codelldb")
	local debugpy = vim.fs.joinpath(data, "mason", "packages", "debugpy", "venv", "bin", "python")
	check(lines, "Rust debugger", vim.fn.executable(codelldb) == 1, codelldb)
	check(lines, "Python debugger", vim.fn.executable(debugpy) == 1, debugpy)

	local firenvim = vim.fs.joinpath(vim.env.HOME, ".local", "share", "firenvim", "firenvim")
	local chrome_manifest = vim.fs.joinpath(
		vim.env.HOME,
		"Library",
		"Application Support",
		"Google",
		"Chrome",
		"NativeMessagingHosts",
		"firenvim.json"
	)
	check(lines, "Firenvim host", vim.fn.executable(firenvim) == 1, firenvim)
	check(lines, "Chrome manifest", vim.uv.fs_stat(chrome_manifest) ~= nil, chrome_manifest)

	local clients = vim.lsp.get_clients({ bufnr = 0 })
	local names = vim.tbl_map(function(client)
		return client.name
	end, clients)
	check(
		lines,
		"Current-buffer LSP",
		#names > 0 and true or nil,
		#names > 0 and table.concat(names, ", ") or "none attached"
	)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "checkhealth"
	vim.cmd("botright split")
	vim.api.nvim_win_set_buf(0, buf)
	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
end

function M.startup_profile()
	local output = vim.fs.joinpath(vim.fn.stdpath("cache"), "vrnm-startuptime.log")
	vim.fn.jobstart({ vim.v.progpath, "--startuptime", output, "--headless", "+qa" }, {
		on_exit = function(_, code)
			vim.schedule(function()
				if code ~= 0 then
					vim.notify("Startup profile failed", vim.log.levels.ERROR)
					return
				end
				vim.cmd("split " .. vim.fn.fnameescape(output))
			end)
		end,
	})
end

vim.api.nvim_create_user_command("ConfigHealth", M.show, { desc = "Check this Neovim configuration" })
vim.api.nvim_create_user_command("StartupProfile", M.startup_profile, { desc = "Profile Neovim startup" })
vim.keymap.set("n", "<leader>ch", M.show, { desc = "Configuration health" })

return M
