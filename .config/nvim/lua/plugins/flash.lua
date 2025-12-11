return {
  "folke/flash.nvim",
  opts = {
    modes = {
      -- enables flash in all search modes, including regular `/` and `?` commands
      search = {
        enabled = true,
      },
      -- enables jump labels for 'f', 'F', 't', 'T' motions
      char = {
        jump_labels = true,
      },
    },
  },
}
