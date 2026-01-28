return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "<leader>tj", desc = "Toggle split/join" },
    { "<leader>ts", desc = "Split" },
    { "<leader>tm", desc = "Join" },
  },
  opts = { use_default_keymaps = false },
  config = function(_, opts)
    local treesj = require("treesj")
    treesj.setup(opts)
    vim.keymap.set("n", "<leader>tj", treesj.toggle, { desc = "Toggle split/join" })
    vim.keymap.set("n", "<leader>ts", treesj.split, { desc = "Split" })
    vim.keymap.set("n", "<leader>tm", treesj.join, { desc = "Join" })
  end,
}
