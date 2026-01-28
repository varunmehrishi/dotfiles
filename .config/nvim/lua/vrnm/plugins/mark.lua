return {
  "inkarkat/vim-mark",
  dependencies = { "inkarkat/vim-ingo-library" },
  event = "VeryLazy",
  init = function()
    vim.g.mw_no_mappings = 1
  end,
  config = function()
    vim.keymap.set("n", "<leader>m", "<Plug>MarkSet", { desc = "Mark word" })
    vim.keymap.set("x", "<leader>m", "<Plug>MarkSet", { desc = "Mark selection" })
    vim.keymap.set("n", "<leader>M", "<Plug>MarkClear", { desc = "Clear mark" })
    vim.keymap.set("n", "<leader>n", "<Plug>MarkSearchNext", { desc = "Next mark" })
    vim.keymap.set("n", "<leader>N", "<Plug>MarkSearchPrev", { desc = "Prev mark" })
  end,
}
