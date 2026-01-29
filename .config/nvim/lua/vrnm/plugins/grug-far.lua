return {
  "MagicDuck/grug-far.nvim",
  keys = {
    { "<leader>sr", function() require("grug-far").open() end, desc = "Search and replace" },
    { "<leader>sr", function() require("grug-far").with_visual_selection() end, mode = "v", desc = "Search selection" },
    { "<leader>sR", function() require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } }) end, desc = "Replace in file" },
  },
  opts = {},
}
