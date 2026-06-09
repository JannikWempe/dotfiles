local fix_on_save = vim.api.nvim_create_augroup("lint_fix_on_save", {})

local function preferred_client(bufnr)
  return vim.lsp.get_clients({ name = "oxlint", bufnr = bufnr })[1]
    or vim.lsp.get_clients({ name = "eslint", bufnr = bufnr })[1]
end

local function fix_all(bufnr)
  local client = preferred_client(bufnr)
  if not client then return end

  if client.name == "oxlint" then
    client:request_sync("workspace/executeCommand", {
      command = "oxc.fixAll",
      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    }, 3000, bufnr)
    return
  end

  if client.name == "eslint" then
    client:request_sync("workspace/executeCommand", {
      command = "eslint.applyAllFixes",
      arguments = {
        {
          uri = vim.uri_from_bufnr(bufnr),
          version = vim.lsp.util.buf_versions[bufnr],
        },
      },
    }, 3000, bufnr)
  end
end

local function setup_fix_on_save(bufnr)
  vim.api.nvim_clear_autocmds({ group = fix_on_save, buffer = bufnr })

  if not preferred_client(bufnr) then return end

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = fix_on_save,
    buffer = bufnr,
    callback = function()
      fix_all(bufnr)
    end,
  })
end

-- Prefer oxlint over eslint when both are available for a buffer.
-- oxlint behavior itself should otherwise follow the built-in lspconfig definition.
vim.lsp.enable("oxlint")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    if client.name ~= "oxlint" and client.name ~= "eslint" then return end

    if client.name == "oxlint" then
      for _, c in ipairs(vim.lsp.get_clients({ name = "eslint", bufnr = args.buf })) do
        c:stop()
      end
    elseif #vim.lsp.get_clients({ name = "oxlint", bufnr = args.buf }) > 0 then
      client:stop()
    end

    setup_fix_on_save(args.buf)
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    setup_fix_on_save(args.buf)
  end,
})

return {}
