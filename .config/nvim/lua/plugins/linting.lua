-- Prefer oxlint when the project has an oxlint config, otherwise eslint.
-- Lint fixes run once on save, before conform (oxfmt/prettier).
-- Requires `vim.g.lazyvim_eslint_auto_format = false` (options.lua).

-- same markers as the oxc extra's oxlint root_dir
local oxlint_configs = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }

local fix_commands = {
  oxlint = "oxc.fixAll",
  eslint = "eslint.applyAllFixes",
}

local function linter(bufnr)
  return vim.lsp.get_clients({ name = "oxlint", bufnr = bufnr })[1]
    or vim.lsp.get_clients({ name = "eslint", bufnr = bufnr })[1]
end

local function fix_all(bufnr)
  local client = linter(bufnr)
  if not client then return end

  client:request_sync("workspace/executeCommand", {
    command = fix_commands[client.name],
    arguments = { { uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] } },
  }, 3000, bufnr)
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      eslint = function(_, opts)
        -- don't start eslint where oxlint is configured
        local root_dir = vim.lsp.config.eslint.root_dir
        opts.root_dir = function(bufnr, on_dir)
          if vim.fs.root(bufnr, oxlint_configs) then return end
          root_dir(bufnr, on_dir)
        end

        -- priority > conform (100): fix first, then format
        LazyVim.format.register({
          name = "lint: fix all",
          primary = false,
          priority = 200,
          format = fix_all,
          sources = function(bufnr)
            local client = linter(bufnr)
            return client and { client.name } or {}
          end,
        })
      end,
    },
  },
}
