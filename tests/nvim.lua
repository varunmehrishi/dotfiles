-- Run with the installed config: nvim --headless -c 'luafile tests/nvim.lua'
local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root .. '/.config/nvim')
local temp = vim.fn.tempname() .. ' dotfiles tests'
vim.fn.mkdir(temp, 'p')
temp = vim.uv.fs_realpath(temp)
local function check()
  require('vrnm.options')
  require('vrnm.lazy')
  require('vrnm.autocommands')
  require('vrnm.formatting')
  require('vrnm.linting')
  local project = require('vrnm.project')
  local warnings = {}
  vim.notify = function(message) table.insert(warnings, message) end
  local captured
  project.run = function(command, opts) captured = { command = command, opts = opts } end
  -- Avoid depending on pytest installation while capturing the generated argv.
  local system = vim.system
  vim.system = function(command, opts)
    if command[2] == '-c' and command[3] == 'import pytest' then
      return { wait = function() return { code = 0 } end }
    end
    return system(command, opts)
  end
  vim.fn.writefile({}, temp .. '/requirements.txt')
  vim.cmd.edit(vim.fn.fnameescape(temp .. '/test_example.py'))
  vim.bo.filetype = 'python'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    'class TestExample:',
    '    def test_method(self):',
    '        assert True',
    '',
    'def helper():',
    '    return True',
  })
  vim.api.nvim_win_set_cursor(0, { 3, 8 })
  assert(project.root(0) == temp, 'requirements.txt must define the project root')
  project.test_nearest()
  assert(captured.command[4] == temp .. '/test_example.py::TestExample::test_method', vim.inspect(captured))
  assert(vim.deep_equal(vim.api.nvim_win_get_cursor(0), { 3, 8 }), 'test lookup moved the cursor')
  captured = nil
  vim.api.nvim_win_set_cursor(0, { 6, 4 })
  project.test_nearest()
  assert(captured == nil, 'a helper must not run an unrelated earlier test')
  -- All tests must see current on-disk content, including another modified buffer.
  vim.cmd.edit(vim.fn.fnameescape(temp .. '/other.py'))
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'value = 42' })
  project.test_all()
  assert(vim.fn.readfile(temp .. '/other.py')[1] == 'value = 42')
  assert(captured.command[3] == 'pytest')
  -- Invalid package.json values and JSON syntax must produce warnings, not crashes.
  local js = temp .. '/js'
  vim.fn.mkdir(js, 'p')
  vim.fn.writefile({ 'const value = 42' }, js .. '/main.js')
  vim.fn.writefile({ 'null' }, js .. '/package.json')
  vim.ui.select = function() error('unexpected task picker') end
  vim.cmd.edit(vim.fn.fnameescape(js .. '/main.js'))
  vim.bo.filetype = 'javascript'
  for _, content in ipairs({ 'null', 'false', '{ broken json', '{"scripts": {}}' }) do
    vim.fn.writefile({content}, js .. '/package.json')
    assert(project.root(0) == js, 'package root was not selected')
    local chosen, err = pcall(project.choose_task)
    assert(chosen, tostring(err))
  end
  -- Large files should stay outside the automatic formatter/linter pipeline.
  local large = temp .. '/large.py'
  vim.fn.writefile({ '# ' .. string.rep('x', 2 * 1024 * 1024) }, large)
  vim.cmd.edit(vim.fn.fnameescape(large))
  assert(vim.b.bigfile == true, 'large file detection failed')
  local conform = require('conform')
  local lint = require('lint')
  local formatting_calls, lint_calls = 0, 0
  conform.format = function() formatting_calls = formatting_calls + 1 end
  lint.try_lint = function() lint_calls = lint_calls + 1 end
  vim.api.nvim_exec_autocmds('BufWritePre', { buffer = 0 })
  vim.api.nvim_exec_autocmds('InsertLeave', { buffer = 0 })
  assert(formatting_calls == 0, 'large buffer formatted automatically')
  assert(lint_calls == 0, 'large buffer linted automatically')
  assert(vim.fn.isdirectory(vim.fn.stdpath('state') .. '/undo') == 1)
  print('PASS Neovim project commands, Python test selection, malformed manifests, and large file guards')
end
local ok, err = xpcall(check, debug.traceback)
vim.fn.delete(temp, 'rf')
if not ok then
  io.stderr:write(err .. '\n')
  vim.cmd('cquit 1')
else
  vim.cmd('qa!')
end
