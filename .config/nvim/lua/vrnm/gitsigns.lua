require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
		delay = 200,
		ignore_whitespace = true,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},

	-- Simplified keybindings for easier use
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']g', function()
			if vim.wo.diff then return ']c' end
			vim.schedule(function() gs.next_hunk() end)
			return '<Ignore>'
		end, {expr=true, desc = "Next Git Hunk"})

		map('n', '[g', function()
			if vim.wo.diff then return '[c' end
			vim.schedule(function() gs.prev_hunk() end)
			return '<Ignore>'
		end, {expr=true, desc = "Previous Git Hunk"})

		-- Actions
		-- Stage
		map('n', '<leader>gs', gs.stage_hunk, {desc = "Git Stage Hunk"})
		map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = "Git Stage Selected"})
		map('n', '<leader>gS', gs.stage_buffer, {desc = "Git Stage Buffer"})

		-- Reset/Undo
		map('n', '<leader>gr', gs.reset_hunk, {desc = "Git Reset Hunk"})
		map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = "Git Reset Selected"})
		map('n', '<leader>gR', gs.reset_buffer, {desc = "Git Reset Buffer"})
		map('n', '<leader>gu', gs.undo_stage_hunk, {desc = "Git Undo Stage"})

		-- Preview/Diff
		map('n', '<leader>gp', gs.preview_hunk, {desc = "Git Preview Hunk"})
		map('n', '<leader>gd', gs.diffthis, {desc = "Git Diff This"})

		-- Blame
		map('n', '<leader>gb', gs.toggle_current_line_blame, {desc = "Git Toggle Blame"})
		map('n', '<leader>gB', function() gs.blame_line{full=true} end, {desc = "Git Full Blame"})

		-- Text object
		map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc = "Git Select Hunk"})
	end,
})
