local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
if (not ts_ok) then
    return
end

ts.setup {
    highlight = {
        enable = true,
        disable = {}
    },
    indent = {
        enable = true,
        disable = {}
    },
    ensure_installed = {"help", "javascript", "typescript", "tsx", "toml", "json", "yaml", "css", "html", "lua"},
    autotag = {
        enable = true
    }
}

local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = {"javascript", "typescript.tsx"}
