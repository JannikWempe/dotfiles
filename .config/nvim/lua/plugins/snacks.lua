return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      -- Show hidden files by default
      hidden = { "preview" },
      -- Show more of the file path in the picker
      -- Because otherwise some files may not be distinguishable
      formatters = {
        file = {
          filename_first = false,
          truncate = "center",
        },
      },
      layout = {
        layout = {
          width = 0.97,
          height = 0.97,
        },
      },
    },
  },
}
