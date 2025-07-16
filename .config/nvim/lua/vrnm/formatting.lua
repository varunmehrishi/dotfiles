local conform_status_ok, conform = pcall(require, "conform")
if not conform_status_ok then
  return
end

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    rust = { "rustfmt" }, -- Uses system rustfmt
    -- c = { "clang_format" }, -- Managed separately
    -- cpp = { "clang_format" }, -- Managed separately
  },

  -- Configure formatters
  formatters = {
    prettier = {
      prepend_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    black = {
      prepend_args = { "--fast" },
    },
  },

  -- Format on save
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- Manual format keymap
vim.keymap.set({ "n", "v" }, "<leader>mp", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format file or range (in visual mode)" })
