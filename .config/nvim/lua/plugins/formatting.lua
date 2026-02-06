-- Skip prettier when oxfmt LSP is attached (oxfmt has workspace_required = true,
-- so it only activates in projects with an oxfmt config file).
-- conform's lsp_format = "fallback" means oxfmt LSP handles formatting instead.

local function oxfmt_attached(_, ctx)
  return #vim.lsp.get_clients({ name = "oxfmt", bufnr = ctx.buf }) == 0
end

vim.lsp.config("oxfmt", {
  cmd = { "npx", "oxfmt", "--lsp" },
  root_markers = { ".oxfmtrc.json", ".oxfmtrc.jsonc" },
})
vim.lsp.enable("oxfmt")

return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      prettierd = { condition = oxfmt_attached },
      prettier = { condition = oxfmt_attached },
    },
  },
}
