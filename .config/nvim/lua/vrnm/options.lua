vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local pynvim_python = vim.fn.expand("$HOME/.local/bin/pynvim-python")
if vim.fn.executable(pynvim_python) == 1 then
  vim.g.python3_host_prog = pynvim_python
end

local options = {
  backup = false,                              -- disable backup files
  completeopt = { "menuone", "noselect" },     -- for cmp
  cursorline = true,                           -- highlight the current line
  expandtab = true,                            -- convert tabs to spaces
  mouse = "a",                                 -- enable mouse
  number = true,                               -- set numbered lines
  numberwidth = 2,                             -- width of number column
  pumheight = 10,                              -- pop up menu height
  relativenumber = false,                      -- set relative numbered lines
  shiftwidth = 2,                              -- the number of spaces inserted for each indentation
  showmode = false,                            -- disabled since cmdheight=0 hides command line
  signcolumn = "yes",                          -- always show sign column
  tabstop = 2,                                 -- insert 2 spaces for a tab
  updatetime = 300,                            -- faster completions
  undodir = os.getenv('HOME') .. '/.undodir',  -- Add undodir for persistent undos
  undofile = true,                             -- enable persistent undos
  writebackup = false,                         -- write backup
  guifont = {'FiraCode Nerd Font', ':h20'},    -- gui font for neovide gui
  cmdheight = 0,                               -- no empty line at bottom waiting for command
  smartindent = false,                         -- use indentation from treesitter
  autoindent = true,                           -- fallback indentation
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.shortmess:append "c"                    -- short message
