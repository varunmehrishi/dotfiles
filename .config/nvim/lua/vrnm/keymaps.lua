local opts = { noremap = true, silent = true }

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
vim.keymap.set('n', '<S-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<S-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<S-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<S-Right>', ':vertical resize +2<CR>', opts)

-- Navigate buffers
vim.keymap.set('n', '<S-l>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<S-d>', ':bdelete<CR>', opts)
vim.keymap.set('n', '<S-x>', ':cclose<CR>', opts)

vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', opts)

local osc_status, osc52 = pcall(require, 'osc52')
if osc_status then
  vim.keymap.set('n', '<leader>y', osc52.copy_operator, {expr = true})
  vim.keymap.set('n', '<leader>yy', '<leader>y_', {remap = true})
  vim.keymap.set('x', '<leader>y', osc52.copy_visual)
end
