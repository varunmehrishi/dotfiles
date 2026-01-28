-- Enhanced diagnostics configuration for better error display
local M = {}

-- Function to show all diagnostics in the current buffer
M.show_buffer_diagnostics = function()
  -- Open a floating window with all diagnostics in the current buffer
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics == 0 then
    vim.notify("No diagnostics found", vim.log.levels.INFO)
    return
  end

  -- Format diagnostics for display
  local formatted = {}
  for i, d in ipairs(diagnostics) do
    local severity = ({
      [1] = "Error",
      [2] = "Warning",
      [3] = "Info",
      [4] = "Hint",
    })[d.severity] or "Unknown"

    local line = d.lnum + 1
    local col = d.col + 1
    local message = d.message
    if d.code then
      message = string.format("[%s %s] Line %d:%d - %s", severity, d.code, line, col, message)
    else
      message = string.format("[%s] Line %d:%d - %s", severity, line, col, message)
    end

    table.insert(formatted, message)
  end

  -- Create a temporary buffer with the diagnostics
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)

  -- Set buffer options
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"

  -- Calculate window size
  local width = math.min(100, vim.o.columns - 10)
  local height = math.min(#formatted + 2, 30)

  -- Create a floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = "Buffer Diagnostics",
    title_pos = "center",
  })

  -- Set window options
  vim.wo[win].wrap = true
  vim.wo[win].cursorline = true

  -- Add keymaps to close the window
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, noremap = true, silent = true })

  -- Add keymap to jump to the diagnostic location
  vim.keymap.set("n", "<CR>", function() require("vrnm.lsp.diagnostics").jump_to_diagnostic() end, { buffer = buf, noremap = true, silent = true })

  -- Store diagnostics in a global variable for the jump function
  vim.g.current_diagnostics = diagnostics
end

-- Setup enhanced diagnostics
M.setup = function()
  -- Configure diagnostics with better display for long messages
  vim.diagnostic.config({
    -- Configure virtual text (more minimal to avoid clutter)
    virtual_text = {
      spacing = 4,
      prefix = "●", -- Use a simple dot as prefix
      format = function(diagnostic)
        -- Only show error code for virtual text to keep it short
        if diagnostic.code then
          return string.format("[%s]", diagnostic.code)
        end
        -- For other diagnostics, just show a short indicator
        return ""
      end,
    },

    -- Show signs in the sign column
    signs = true,

    -- Don't update diagnostics in insert mode to avoid distraction
    update_in_insert = false,

    -- Always underline issues
    underline = true,

    -- Sort by severity (errors first)
    severity_sort = true,

    -- Enhanced floating window configuration
    float = {
      -- Make the window focusable so you can scroll in it
      focusable = true,

      -- Use a more visible style
      style = "minimal",

      -- Rounded borders look nicer
      border = "rounded",

      -- Always show the source of the diagnostic
      source = "if_many",

      -- Add a header to separate the source from the message
      header = "Diagnostic",

      -- Add a prefix to make it clear
      prefix = "",

      -- Format the diagnostic message for better readability
      format = function(diagnostic)
        -- Get the severity as a string
        local severity = ({
          [1] = "Error",
          [2] = "Warning",
          [3] = "Info",
          [4] = "Hint",
        })[diagnostic.severity] or "Unknown"

        -- Format the message with severity and code if available
        local message = diagnostic.message
        if diagnostic.code then
          message = string.format("[%s %s] %s", severity, diagnostic.code, message)
        else
          message = string.format("[%s] %s", severity, message)
        end

        return message
      end,

      -- Increase max width and height for larger diagnostics
      max_width = 100,
      max_height = 20,
    },
  })

  -- Override the default hover handler for better formatting
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    max_width = 100,
    max_height = 30,
  })

  -- Override the default signature help handler
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    max_width = 100,
    max_height = 20,
  })
end

-- Function to jump to a diagnostic from the diagnostics window
M.jump_to_diagnostic = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local diagnostic = vim.g.current_diagnostics[line]
  if diagnostic then
    -- Close the diagnostics window
    vim.cmd("close")

    -- Jump to the diagnostic location
    vim.api.nvim_win_set_cursor(0, { diagnostic.lnum + 1, diagnostic.col })

    -- Open a float with just this diagnostic
    vim.diagnostic.open_float({ scope = "cursor" })
  end
end

return M
