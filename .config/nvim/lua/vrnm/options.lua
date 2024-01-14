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
  showmode = true,                             -- show current mode --INSERT--
  signcolumn = "yes",                          -- always show sign column
  tabstop = 2,                                 -- insert 2 spaces for a tab
  updatetime = 300,                            -- faster completions
  undodir = os.getenv('HOME') .. '/.undodir',  -- Add undodir for persistent undos
  undofile = true,                             -- enable persistent undos
  writebackup = false,                         -- write backup
  guifont = {'FiraCode Nerd Font', ':h20'},    -- gui font for neovide gui
  cmdheight = 0,                               -- no empty line at bottom waiting for command
  smartindent = false                          -- use indentation from treesitter
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.shortmess:append "c"                    -- short message
