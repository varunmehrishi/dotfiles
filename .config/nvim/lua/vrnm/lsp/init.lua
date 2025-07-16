require "vrnm.lsp.configs"
require("vrnm.lsp.handlers").setup()
require("vrnm.lsp.diagnostics").setup() -- Add enhanced diagnostics
-- null-ls removed - now using conform.nvim and nvim-lint
