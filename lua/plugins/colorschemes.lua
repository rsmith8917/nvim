-- ============================================================================
-- COLORSCHEMES
-- ============================================================================

return {
    {
        "catppuccin/nvim",
        lazy = false,
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                integrations = {
                    treesitter = true,
                    telescope = true,
                    cmp = true,
                    gitsigns = true,
                    neotree = true,
                    native_lsp = {
                        enabled = true,
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "undercurl" },
                            warnings = { "undercurl" },
                            information = { "undercurl" },
                        },
                    },
                },
            })
        end,
    },

    {
        "Mofiqul/vscode.nvim",
        priority = 1000,
        config = function()
            require("vscode").setup({
                transparent = false,
                italic_comments = true,
                disable_nvimtree_bg = true,
            })
        end,
    },

    { "folke/tokyonight.nvim", priority = 1000 },

    -- Set default colorscheme (load after all theme plugins)
    {
        "default-colorscheme",
        dir = vim.fn.stdpath("config"),
        priority = 999,
        config = function()
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },
}
