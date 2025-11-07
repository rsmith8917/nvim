-- ============================================================================
-- OPENAPI SPEC TOOLS
-- ============================================================================

return {
    -- OpenAPI preview and tooling
    {
        "vinnymeller/swagger-preview.nvim",
        build = "npm install",
        config = function()
            require("swagger-preview").setup({
                -- Port for the preview server
                port = 8765,
                -- Host for the preview server
                host = "localhost",
            })
        end,
    },
}
