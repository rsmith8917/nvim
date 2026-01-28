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

    { "folke/tokyonight.nvim",       priority = 1000 },
    { "ellisonleao/gruvbox.nvim",    priority = 1000 },
    { "shaunsingh/nord.nvim",        priority = 1000 },
    { "navarasu/onedark.nvim",       priority = 1000 },
    { "Mofiqul/dracula.nvim",        priority = 1000 },
    { "rose-pine/neovim",            name = "rose-pine", priority = 1000 },
    { "rebelot/kanagawa.nvim",       priority = 1000 },
    { "EdenEast/nightfox.nvim",      priority = 1000 },
    { "sainnhe/everforest",          priority = 1000 },

    -- High contrast themes
    { "projekt0n/github-nvim-theme", priority = 1000 },
    { "sainnhe/sonokai",             priority = 1000 },
    { "bluz71/vim-moonfly-colors",   name = "moonfly",   priority = 1000 },
    { "bluz71/vim-nightfly-colors",  name = "nightfly",  priority = 1000 },
    { "Shatur/neovim-ayu",           priority = 1000 },
    { "sainnhe/edge",                priority = 1000 },

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
