return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
        -- Don't ask about luassert, busted, etc.
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true, -- Enable inlay hints
      },
    },
  },
}
