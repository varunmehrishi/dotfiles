-- Mason setup with auto-installation of tools
local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  return
end

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
  return
end

-- Setup Mason
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    },
    border = "rounded",
  },
  max_concurrent_installers = 10,
})

-- LSP servers to auto-install
local servers = {
  "lua_ls",           -- Lua
  -- "rust_analyzer", -- Rust (managed separately)
  "clangd",          -- C/C++
  "ts_ls",           -- TypeScript/JavaScript (updated from tsserver)
  "pyright",         -- Python
  "jsonls",          -- JSON
  "yamlls",          -- YAML
  "bashls",          -- Bash
  -- "gopls",        -- Go (removed - not used)
  "html",            -- HTML
  "cssls",           -- CSS
}

-- Setup mason-lspconfig
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-- Auto-install formatters and linters
-- We'll use a simple approach since mason-tool-installer might not be available
local function ensure_installed(tools)
  local registry_ok, registry = pcall(require, "mason-registry")
  if not registry_ok then
    return
  end

  for _, tool in ipairs(tools) do
    if registry.has_package(tool) then
      local p = registry.get_package(tool)
      if not p:is_installed() then
        print("Installing " .. tool)
        p:install()
      end
    else
      print("Package not found in Mason registry: " .. tool)
    end
  end
end

-- Tools for formatting and linting
local tools = {
  -- Formatters
  "stylua",          -- Lua formatter
  "prettier",        -- JS/TS/JSON/YAML/etc formatter
  "black",           -- Python formatter
  -- "clang-format", -- C/C++ formatter (managed separately)

  -- Linters
  "flake8",          -- Python linter
  "eslint_d",        -- JS/TS linter (faster than eslint)
  -- Note: cppcheck might not be available in Mason registry
  -- We'll handle C/C++ linting differently
}

-- Install tools after Mason is ready
vim.api.nvim_create_autocmd("User", {
  pattern = "MasonRegistryReady",
  callback = function()
    ensure_installed(tools)
  end,
})

-- If Mason registry is already ready, install immediately
if pcall(require, "mason-registry") then
  ensure_installed(tools)
end
