local options = {
  backup = false,                          -- disable backup files
  completeopt = { "menuone", "noselect" }, -- for cmp
  cursorline = true,                       -- highlight the current line
  expandtab = true,                        -- convert tabs to spaces
  mouse = "a",				   -- enable mouse
  number = true,                           -- set numbered lines
  numberwidth = 2,                         -- width of number column
  pumheight = 10,                          -- pop up menu height
  relativenumber = false,                  -- set relative numbered lines
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  showmode = true,                         -- show current mode --INSERT--
  signcolumn = "yes",                      -- always show sign column
  tabstop = 2,                             -- insert 2 spaces for a tab
  updatetime = 300,                        -- faster completions
  writebackup = false,                     -- write backup
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.shortmess:append "c"                    -- short message
