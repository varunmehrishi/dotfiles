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

-- Undo history via Telescope
vim.keymap.set('n', '<leader>u', '<cmd>Telescope undo<CR>', opts)

-- Git fugitive
vim.keymap.set('n', '<leader>gg', ':G<CR>', opts)
-- fugitive 3 way merge mappings
vim.keymap.set('n', '<leader>gf', ':diffget //2<CR>', opts)
vim.keymap.set('n', '<leader>gj', ':diffget //3<CR>', opts)

vim.keymap.set('n', '<leader>y', '"*yiw', opts)
vim.keymap.set('n', '<leader>yy', '"*yy', opts)
vim.keymap.set('x', '<leader>y', '"*y', opts)

vim.keymap.set('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>')

-- Neotree removed, use <leader>e for oil.nvim instead

-- Global LSP keymaps (don't require LSP buffer)
vim.keymap.set('n', '<leader>li', '<cmd>LspInfo<CR>', opts) -- LSP info
vim.keymap.set('n', '<leader>lI', '<cmd>Mason<CR>', opts) -- Mason info
vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<CR>', opts) -- Restart LSP

-- venn.nvim: enable or disable keymappings
function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { buffer = 0, noremap = true })
        vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { buffer = 0, noremap = true })
        vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { buffer = 0, noremap = true })
        vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { buffer = 0, noremap = true })
        -- draw a box by pressing "f" with visual selection
        vim.keymap.set("v", "f", ":VBox<CR>", { buffer = 0, noremap = true })
    else
        vim.cmd[[setlocal ve=]]
        vim.keymap.del("n", "J", { buffer = 0 })
        vim.keymap.del("n", "K", { buffer = 0 })
        vim.keymap.del("n", "L", { buffer = 0 })
        vim.keymap.del("n", "H", { buffer = 0 })
        vim.keymap.del("v", "f", { buffer = 0 })
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>v
vim.keymap.set('n', '<leader>v', Toggle_venn, { noremap = true })
