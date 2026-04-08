-- Skip prettier when oxfmt LSP is attached (oxfmt has workspace_required = true,
-- so it only activates in projects with an oxfmt config file).
-- conform's lsp_format = "fallback" means oxfmt LSP handles formatting instead.

local function oxfmt_attached(_, ctx)
  return #vim.lsp.get_clients({ name = "oxfmt", bufnr = ctx.buf }) == 0
end

local function js_lsp_format_opts(bufnr)
  local has_oxfmt = #vim.lsp.get_clients({ name = "oxfmt", bufnr = bufnr }) > 0

  if has_oxfmt then
    return {
      lsp_format = "prefer",
      filter = function(client)
        return client.name == "oxfmt"
      end,
    }
  end

  return {
    lsp_format = "fallback",
  }
end

vim.lsp.config("oxfmt", {
  cmd = { "npx", "oxfmt", "--lsp" },
  root_markers = { ".oxfmtrc.json", ".oxfmtrc.jsonc" },
})
vim.lsp.enable("oxfmt")

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = js_lsp_format_opts,
      javascriptreact = js_lsp_format_opts,
      typescript = js_lsp_format_opts,
      typescriptreact = js_lsp_format_opts,
    },
    formatters = {
      prettierd = { condition = oxfmt_attached },
      prettier = { condition = oxfmt_attached },
    },
  },
}
