-- I have this here because without it, eslint did not work on save...
return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      eslint = function()
        local formatter = require("lazyvim.util").lsp.formatter({
          name = "eslint: lsp",
          primary = false,
          priority = 200,
          filter = "eslint",
        })

        require("lazyvim.util").format.register(formatter)
      end,
    },
  },
}
