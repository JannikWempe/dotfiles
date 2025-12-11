return {
  "lewis6991/gitsigns.nvim",
  keys = {
    {
      "<leader>gn",
      function()
        require("gitsigns").nav_hunk("next")
      end,
      desc = "Next git hunk",
    },
    {
      "<leader>gp",
      function()
        require("gitsigns").nav_hunk("prev")
      end,
      desc = "Previous git hunk",
    },
  },
}

