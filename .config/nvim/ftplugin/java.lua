local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  return
end

local handlers = require("vrnm.lsp.handlers")

-- Root dir detection: Brazil workspace markers, then standard Java markers
local root_dir = jdtls.setup.find_root({ "packageInfo", "Config", ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
if not root_dir then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.expand("~/.local/share/eclipse/" .. project_name)

-- Bemol integration: read workspace folders from .bemol/ws_root_folders
local function get_bemol_workspace_folders()
  local folders = {}
  local bemol_file = root_dir .. "/.bemol/ws_root_folders"
  local f = io.open(bemol_file, "r")
  if f then
    for line in f:lines() do
      line = vim.trim(line)
      if line ~= "" then
        table.insert(folders, { name = line, uri = vim.uri_from_fname(line) })
      end
    end
    f:close()
  end
  return folders
end

-- Build jdtls command
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
if not mason_registry_ok then
  return
end

local ok_pkg, jdtls_pkg = pcall(mason_registry.get_package, "jdtls")
if not ok_pkg or not jdtls_pkg:is_installed() then
  vim.notify("jdtls is not installed via Mason. Run :MasonInstall jdtls", vim.log.levels.WARN)
  return
end

local install_location = require("mason-core.installer.InstallLocation").global()
local jdtls_path = install_location:package(jdtls_pkg.name)
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher_jar == "" then
  vim.notify("jdtls launcher jar not found", vim.log.levels.ERROR)
  return
end

-- Platform-specific config dir
local os_config
if vim.fn.has("mac") == 1 then
  os_config = "config_mac"
elseif vim.fn.has("unix") == 1 then
  os_config = "config_linux"
else
  os_config = "config_win"
end

local cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-Xmx1g",
  "--add-modules=ALL-SYSTEM",
  "--add-opens", "java.base/java.util=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  "-jar", launcher_jar,
  "-configuration", jdtls_path .. "/" .. os_config,
  "-data", workspace_dir,
}

-- Lombok support (gracefully skipped if missing)
local lombok_path = vim.fn.expand("~/.local/share/java/lombok.jar")
if vim.fn.filereadable(lombok_path) == 1 then
  table.insert(cmd, 2, "-javaagent:" .. lombok_path)
end

local bemol_folders = get_bemol_workspace_folders()

local config = {
  cmd = cmd,
  root_dir = root_dir,
  on_attach = function(client, bufnr)
    handlers.on_attach(client, bufnr)

    -- Java-specific keymaps
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
    vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
    vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
    vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, opts)
    vim.keymap.set("n", "<leader>ju", "<cmd>JdtUpdateConfig<cr>", opts)
  end,
  capabilities = handlers.capabilities,
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },
  init_options = {
    workspaceFolders = bemol_folders,
  },
}

jdtls.start_or_attach(config)
