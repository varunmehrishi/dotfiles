local M = {}

local function lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- Navigation
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gu", vim.lsp.buf.references, opts)

  -- Documentation & Help
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded", max_width = 100, max_height = 30 })
  end, opts)
  vim.keymap.set("n", "<leader>k", function()
    vim.lsp.buf.signature_help({ border = "rounded", max_width = 100, max_height = 20 })
  end, opts)
  vim.keymap.set("i", "<C-h>", function()
    vim.lsp.buf.signature_help({ border = "rounded", max_width = 100, max_height = 20 })
  end, opts)

  -- Code Actions & Refactoring
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  -- Formatting
  vim.keymap.set("n", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
  vim.keymap.set("v", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, opts)

  -- Diagnostics
  vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
  vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, opts)
  vim.keymap.set("n", "<leader>dd", function()
    require("vrnm.lsp.diagnostics").show_buffer_diagnostics()
  end, opts)
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = { border = "rounded" } })
  end, opts)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = { border = "rounded" } })
  end, opts)
  vim.keymap.set("n", "[e", function()
    require("vrnm.lsp.diagnostics").jump_error(-1)
  end, opts)
  vim.keymap.set("n", "]e", function()
    require("vrnm.lsp.diagnostics").jump_error(1)
  end, opts)
  vim.keymap.set("n", "<leader>dt", function()
    require("vrnm.lsp.diagnostics").toggle()
  end, opts)
  vim.keymap.set("n", "<leader>dv", function()
    require("vrnm.lsp.diagnostics").cycle_display()
  end, opts)
  vim.keymap.set("n", "<leader>dy", function()
    require("vrnm.lsp.diagnostics").copy_at_cursor()
  end, opts)

  -- Workspace
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)

  -- Telescope LSP integration
  local telescope_ok, builtin = pcall(require, "telescope.builtin")
  if telescope_ok then
    vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, opts)
    vim.keymap.set("n", "<leader>lS", builtin.lsp_workspace_symbols, opts)
    vim.keymap.set("n", "<leader>lr", builtin.lsp_references, opts)
    vim.keymap.set("n", "<leader>ld", builtin.diagnostics, opts)
  end

  -- Inlay Hints
  if vim.lsp.inlay_hint then
    vim.keymap.set("n", "<leader>lh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, opts)
  end

  -- Codelens
  vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, opts)
  vim.keymap.set("n", "<leader>cr", vim.lsp.codelens.refresh, opts)
end

M.on_attach = function(client, bufnr)
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end
  lsp_keymaps(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
