require("telescope").setup({
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
		undo = {
			use_delta = true,
			use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
			side_by_side = false,
			vim_diff_opts = { ctxlen = 8 },
			entry_format = "state #$ID, $STAT, $TIME",
			time_format = "",
			saved_only = false,
		},
	},
	defaults = {
		path_display = { "smart" },
		layout_config = {
			horizontal = {
				height = 0.95,
				preview_cutoff = 120,
				prompt_position = "bottom",
				width = 0.95,
			},
		},
	},
})

require("telescope").load_extension("ui-select")
require("telescope").load_extension("undo")
require("telescope").load_extension("file_browser")
-- Enable telescope fzf native, if installed
require("telescope").load_extension("fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>h", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>s", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		previewer = false,
		layout_config = {
			center = {
				height = 0.8,
				width = 0.8,
			},
		},
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>p", require("telescope.builtin").git_files, { desc = "[P]Git Files" })
vim.keymap.set("n", "<leader>o", require("telescope.builtin").find_files, { desc = "[O]Search Files" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set(
	"n",
	"<leader>fb",
	require("telescope").extensions.file_browser.file_browser,
	{ desc = "[F]ile [B]rowser" }
)

-- Additional LSP-specific telescope keymaps
vim.keymap.set("n", "<leader>ss", require("telescope.builtin").lsp_document_symbols, { desc = "[S]earch [S]ymbols (Document)" })
vim.keymap.set("n", "<leader>sS", require("telescope.builtin").lsp_workspace_symbols, { desc = "[S]earch [S]ymbols (Workspace)" })

-- Git integration (essential missing features)
vim.keymap.set("n", "<leader>gc", require("telescope.builtin").git_commits, { desc = "[G]it [C]ommits" })
vim.keymap.set("n", "<leader>gB", require("telescope.builtin").git_branches, { desc = "[G]it [B]ranches" })
-- Note: <leader>gs used by gitsigns for stage hunk, use <leader>gh for git status with hunk actions
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })

-- Alternative to GitSigns extension - use built-in git_status with file focus
vim.keymap.set("n", "<leader>gh", function()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local gitsigns = require("gitsigns")

  require("telescope.builtin").git_status({
    initial_mode = "normal",
    attach_mappings = function(prompt_bufnr, map)
      -- Define actions that can be performed on hunks
      local apply_action = function(action_func)
        return function()
          local selection = action_state.get_selected_entry()
          if selection then
            actions.close(prompt_bufnr)
            -- Open the file
            vim.cmd("edit " .. selection.value)
            -- Apply the action after a short delay to ensure file is loaded
            vim.defer_fn(function()
              action_func()
            end, 100)
          end
        end
      end

      -- Add mappings for gitsigns actions
      map("n", "s", apply_action(function() gitsigns.stage_hunk() end), { desc = "Stage hunk" })
      map("n", "r", apply_action(function() gitsigns.reset_hunk() end), { desc = "Reset hunk" })
      map("n", "u", apply_action(function() gitsigns.undo_stage_hunk() end), { desc = "Undo stage hunk" })
      map("n", "p", apply_action(function() gitsigns.preview_hunk() end), { desc = "Preview hunk" })
      map("n", "d", apply_action(function() gitsigns.diffthis() end), { desc = "Diff this" })

      -- Add a custom help message
      map("n", "?", function()
        local help_message = [[
Git Hunks Actions:
-----------------
s: Stage hunk
r: Reset hunk
u: Undo stage hunk
p: Preview hunk
d: Diff this file
<CR>: Open file
<Esc>: Close this window
        ]]
        print(help_message)
      end, { desc = "Show help" })

      -- Keep default mappings
      return true
    end
  })
end, { desc = "[G]it Changes with [H]unk Actions" })

-- Vim internals (very useful for exploring)
vim.keymap.set("n", "<leader>vh", require("telescope.builtin").help_tags, { desc = "[V]im [H]elp" })
vim.keymap.set("n", "<leader>vk", require("telescope.builtin").keymaps, { desc = "[V]im [K]eymaps" })
vim.keymap.set("n", "<leader>vc", require("telescope.builtin").commands, { desc = "[V]im [C]ommands" })

-- Quick access to Telescope commands
vim.keymap.set("n", "<leader>t", "<cmd>Telescope<CR>", { desc = "Open Telescope command palette" })
vim.keymap.set("n", "<leader>T", function()
  -- Create a custom picker for common Telescope commands
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Define the commands
  local commands = {
    { name = "Find Files", action = "find_files" },
    { name = "Live Grep", action = "live_grep" },
    { name = "Buffers", action = "buffers" },
    { name = "Help Tags", action = "help_tags" },
    { name = "Git Files", action = "git_files" },
    { name = "Git Status", action = "git_status" },
    { name = "Git Commits", action = "git_commits" },
    { name = "Git Branches", action = "git_branches" },
    { name = "Commands", action = "commands" },
    { name = "Command History", action = "command_history" },
    { name = "Search History", action = "search_history" },
    { name = "Marks", action = "marks" },
    { name = "Registers", action = "registers" },
    { name = "Keymaps", action = "keymaps" },
    { name = "File Browser", action = "file_browser" },
    { name = "Colorschemes", action = "colorscheme" },
    { name = "Undo History", action = "undo" },
  }

  -- Create and run the picker
  pickers.new({}, {
    prompt_title = "Telescope Commands",
    finder = finders.new_table({
      results = commands,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        local action = selection.value.action
        if action == "file_browser" then
          require("telescope").extensions.file_browser.file_browser()
        elseif action == "undo" then
          require("telescope").extensions.undo.undo()
        else
          require("telescope.builtin")[action]()
        end
      end)
      return true
    end,
  }):find()
end, { desc = "Telescope menu" })

-- Quick shortcuts
vim.keymap.set("n", "<leader>/", require("telescope.builtin").live_grep, { desc = "Quick Live Grep" })
