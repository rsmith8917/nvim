-- ============================================================================
-- COLORSCHEMES
-- ============================================================================

return {
    {
        "olivercederborg/poimandres.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("poimandres").setup({
                disable_italics = false,
            })
            vim.cmd.colorscheme("poimandres")
        end,
    },
}
