-- Use oxlint instead of eslint in projects with oxlint config.
-- Both have workspace_required = true, so they only activate where configured.
-- When oxlint attaches, eslint is stopped for that project (and vice versa on attach order).

vim.lsp.config("oxlint", {
  cmd = { "npx", "oxlint", "--lsp" },
})
vim.lsp.enable("oxlint")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client.name == "oxlint" then
      for _, c in ipairs(vim.lsp.get_clients({ name = "eslint", bufnr = args.buf })) do
        c:stop()
      end
    elseif client.name == "eslint" then
      if #vim.lsp.get_clients({ name = "oxlint", bufnr = args.buf }) > 0 then
        client:stop()
      end
    end
  end,
})

return {}
