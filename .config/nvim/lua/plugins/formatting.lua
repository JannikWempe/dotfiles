local js_formatters = { "oxfmt", "prettier", stop_after_first = true }

return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters = opts.formatters or {}

    opts.formatters.oxfmt = {
      require_cwd = true,
      cwd = require("conform.util").root_file({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }),
    }

    for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
      opts.formatters_by_ft[ft] = vim.deepcopy(js_formatters)
    end
  end,
}
