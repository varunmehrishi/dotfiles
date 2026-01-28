return {
  url = "https://codeberg.org/andyg/leap.nvim",
  keys = { "s", "S", "gS" }, -- Lazy load on first use
  config = function()
    vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
    vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })
    vim.keymap.set({ "o" }, "x", "<Plug>(leap-forward-till)", { desc = "Leap forward till" })
    vim.keymap.set({ "o" }, "X", "<Plug>(leap-backward-till)", { desc = "Leap backward till" })
    vim.keymap.set({ "n", "x", "o" }, "gS", "<Plug>(leap-from-window)", { desc = "Leap from window" })
  end,
}
