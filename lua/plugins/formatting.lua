-- ============================================================================
-- CODE FORMATTING
-- ============================================================================

return {
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    c = { "clang_format" },
                    cpp = { "clang_format" },
                    css = { "prettier" },
                    go = { "gofmt" },
                    html = { "prettier" },
                    javascript = { "prettier" },
                    javascriptreact = { "prettier" },
                    json = { "prettier" },
                    lua = { "stylua" },
                    python = { "black" },
                    typescript = { "prettier" },
                    typescriptreact = { "prettier" },
                    yaml = { "prettier" },
                },
            })
        end,
    },
}
