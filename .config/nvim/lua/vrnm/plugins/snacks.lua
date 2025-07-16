return {
  "folke/snacks.nvim",
  event = "VeryLazy", -- Load after startup
  opts = {
    -- Show snacks in the statusline
    statusline = {
      -- Enable statusline integration
      enabled = true,
      -- Show snacks on the right side of the statusline
      side = "right",
    },

    -- Configure which snacks to show
    snacks = {
      -- LSP status (errors, warnings, etc.)
      lsp = {
        enabled = true,
        -- Show errors in red
        error = { icon = "󰅚 ", color = "DiagnosticError" },
        -- Show warnings in yellow
        warn = { icon = "󰀪 ", color = "DiagnosticWarn" },
        -- Show info in blue
        info = { icon = "󰋽 ", color = "DiagnosticInfo" },
        -- Show hints in gray
        hint = { icon = "󰌶 ", color = "DiagnosticHint" },
      },

      -- Git status (branch, changes)
      git = {
        enabled = true,
        -- Show branch name
        branch = { icon = "󰘬 ", color = "GitSignsAdd" },
        -- Show added lines
        added = { icon = " ", color = "GitSignsAdd" },
        -- Show changed lines
        changed = { icon = " ", color = "GitSignsChange" },
        -- Show deleted lines
        removed = { icon = " ", color = "GitSignsDelete" },
      },

      -- File info (type, size, etc.)
      file = {
        enabled = true,
        -- Show file type
        type = { icon = " ", color = "Type" },
        -- Show file size
        size = { icon = "󰛸 ", color = "Special" },
        -- Show file encoding
        encoding = { icon = "󰭹 ", color = "NonText" },
      },

      -- Macro recording indicator
      macro = {
        enabled = true,
        -- Show when recording a macro
        recording = { icon = "󰑋 ", color = "Macro" },
      },

      -- Custom snacks
      custom = {
        -- Show current project
        project = {
          enabled = true,
          icon = "󰏗 ",
          color = "Directory",
          get = function()
            local cwd = vim.fn.getcwd()
            return vim.fn.fnamemodify(cwd, ":t")
          end,
        },

        -- Show current LSP server
        lsp_server = {
          enabled = true,
          icon = "󰒋 ",
          color = "Function",
          get = function()
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            if #clients > 0 then
              return clients[1].name
            end
            return nil
          end,
        },
      },
    },
  },
}
