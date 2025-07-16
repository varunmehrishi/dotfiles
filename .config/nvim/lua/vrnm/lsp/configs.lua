-- Load Mason setup first
require("vrnm.mason-setup")

local lspconfig = require("lspconfig")

local servers = { "jsonls", "lua_ls", "clangd", "ts_ls", "yamlls", "pyright", "bashls", "html", "cssls"}
-- Note: rust_analyzer removed as it's managed separately

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("vrnm.lsp.handlers").on_attach,
    capabilities = require("vrnm.lsp.handlers").capabilities,
  }

  local has_custom_opts, server_custom_opts = pcall(require, "vrnm.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
  end

  lspconfig[server].setup(opts)
end
