local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = true,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end
  illuminate.on_attach(client)
  -- end
end

local function lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- Navigation (using 'g' prefix for LSP navigation)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts) -- NEW: Go to type definition
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gR", vim.lsp.buf.references, opts) -- Changed to gR to avoid conflicts
  vim.keymap.set("n", "gu", vim.lsp.buf.references, opts) -- Also keep gu for backward compatibility

  -- Documentation & Help
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts) -- Changed from <C-k> to avoid conflict
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts) -- NEW: Signature help in insert mode

  -- Code Actions & Refactoring (using <leader> prefix)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, opts) -- NEW: Code actions in visual mode
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  -- Formatting
  vim.keymap.set("n", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, opts) -- Changed from :Format command
  vim.keymap.set("v", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, opts) -- NEW: Format selection

  -- Diagnostics (using <leader>d prefix for consistency)
  vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, opts) -- Changed from <leader>f
  vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts) -- Changed from <leader>q
  vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, opts) -- NEW: Set quickfix list
  vim.keymap.set("n", "<leader>dd", function()
    -- This will be overridden by our enhanced diagnostics module
    require("vrnm.lsp.diagnostics").show_buffer_diagnostics()
  end, opts) -- NEW: Show all diagnostics in buffer
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev({ border = "rounded" })
  end, opts)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next({ border = "rounded" })
  end, opts)

  -- Workspace (using <leader>w prefix)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts) -- NEW
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts) -- NEW
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts) -- NEW

  -- Telescope LSP integration (if telescope is available)
  local telescope_ok, builtin = pcall(require, "telescope.builtin")
  if telescope_ok then
    vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, opts) -- Document symbols
    vim.keymap.set("n", "<leader>lS", builtin.lsp_workspace_symbols, opts) -- Workspace symbols
    vim.keymap.set("n", "<leader>lr", builtin.lsp_references, opts) -- References in telescope
    vim.keymap.set("n", "<leader>ld", builtin.diagnostics, opts) -- Diagnostics in telescope
  end

  -- Inlay Hints (modern LSP feature)
  if vim.lsp.inlay_hint then
    vim.keymap.set("n", "<leader>lh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, opts) -- NEW: Toggle inlay hints
  end

  -- Codelens (if supported)
  vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, opts) -- NEW: Run codelens
  vim.keymap.set("n", "<leader>cr", vim.lsp.codelens.refresh, opts) -- NEW: Refresh codelens
end

M.on_attach = function(client, bufnr)
  -- vim.notify(client.name .. " starting...")
  -- TODO: refactor this into a method that checks if string in list
  if client.name == "ts_ls" then
    -- Use server_capabilities instead of deprecated client.server_capabilities
    client.server_capabilities.documentFormattingProvider = false
  end
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
