local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

mason.setup {
  ui = {
    icons = {
      package_installed = "✓"
    }
  }
}

local status_ok_lsp, lsp_installer = pcall(require, "mason-lspconfig")
if not status_ok_lsp then
  return
end

-- require('java').setup()

local lspconfig = require("lspconfig")

local servers = { "jsonls", "lua_ls", "rust_analyzer", "clangd", "ts_ls", "yamlls"}

lsp_installer.setup {
  ensure_installed = servers
}

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("vrnm.lsp.handlers").on_attach,
    capabilities = require("vrnm.lsp.handlers").capabilities,
  }

  if server == "rust_analyzer" then
    local keymap = vim.keymap.set
    local key_opts = { silent = true }

    keymap("n", "<leader>rh", "<cmd>RustSetInlayHints<Cr>", key_opts)
    keymap("n", "<leader>rhd", "<cmd>RustDisableInlayHints<Cr>", key_opts)
    keymap("n", "<leader>th", "<cmd>RustToggleInlayHints<Cr>", key_opts)
    keymap("n", "<leader>rr", "<cmd>RustRunnables<Cr>", key_opts)
    keymap("n", "<leader>rem", "<cmd>RustExpandMacro<Cr>", key_opts)
    keymap("n", "<leader>roc", "<cmd>RustOpenCargo<Cr>", key_opts)
    keymap("n", "<leader>rpm", "<cmd>RustParentModule<Cr>", key_opts)
    keymap("n", "<leader>rjl", "<cmd>RustJoinLines<Cr>", key_opts)
    keymap("n", "<leader>rha", "<cmd>RustHoverActions<Cr>", key_opts)
    keymap("n", "<leader>rhr", "<cmd>RustHoverRange<Cr>", key_opts)
    keymap("n", "<leader>rmd", "<cmd>RustMoveItemDown<Cr>", key_opts)
    keymap("n", "<leader>rmu", "<cmd>RustMoveItemUp<Cr>", key_opts)
    keymap("n", "<leader>rsb", "<cmd>RustStartStandaloneServerForBuffer<Cr>", key_opts)
    keymap("n", "<leader>rd", "<cmd>RustDebuggables<Cr>", key_opts)
    keymap("n", "<leader>rv", "<cmd>RustViewCrateGraph<Cr>", key_opts)
    keymap("n", "<leader>rw", "<cmd>RustReloadWorkspace<Cr>", key_opts)
    keymap("n", "<leader>rss", "<cmd>RustSSR<Cr>", key_opts)
    keymap("n", "<leader>rxd", "<cmd>RustOpenExternalDocs<Cr>", key_opts)

    vim.g.rustaceanvim = {
      tools = {
        on_initialized = function()
          vim.cmd [[
            autocmd BufEnter,CursorHold,InsertLeave,BufWritePost *.rs silent! lua vim.lsp.codelens.refresh()
          ]]
        end,
      },
      server = {
        on_attach = opts.on_attach,
        capabilities = opts.capabilities,
        settings = {
          ["rust-analyzer"] = {
            lens = {
              enable = true,
            },
            checkOnSave = {
              command = "clippy"
            }
          }
        }
      }
    }
    goto continue
  end

  local has_custom_opts, server_custom_opts = pcall(require, "vrnm.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
  end

  lspconfig[server].setup(opts)

  ::continue::
end
