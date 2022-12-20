local mason_ok, mason = pcall(require, "mason")
local lspconfig_ok, lspconfig = pcall(require, "mason-lspconfig")
if (not mason_ok or not lspconfig_ok) then
    return
end

mason.setup({})

lspconfig.setup {
    automatic_installation = true
}
