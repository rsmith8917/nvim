-- ============================================================================
-- COLORSCHEMES
-- ============================================================================

return {
    {
        "catppuccin/nvim",
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
        "EdenEast/nightfox.nvim",
        priority = 1000,
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = false,
                    dim_inactive = false,
                },
            })
        end,
    },

    {
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "moon", -- storm, moon, night, day
                transparent = false,
                terminal_colors = true,
            })
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                variant = "main", -- auto, main, moon, or dawn
                dark_variant = "main",
            })
        end,
    },

    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                transparent = false,
            })
        end,
    },

    {
        "Mofiqul/dracula.nvim",
        priority = 1000,
        config = function()
            require("dracula").setup()
        end,
    },

    {
        "projekt0n/github-nvim-theme",
        name = "github-theme",
        priority = 1000,
        config = function()
            require("github-theme").setup({
                options = {
                    transparent = false,
                    terminal_colors = true,
                    dim_inactive = false,
                    styles = {
                        comments = "italic",
                        functions = "NONE",
                        keywords = "bold",
                        variables = "NONE",
                    },
                },
            })
        end,
    },

    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                contrast = "", -- Can be "hard", "soft" or empty string
                transparent_mode = false,
                terminal_colors = true,
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

    {
        "datsfilipe/vesper.nvim",
        priority = 1000,
    },

    {
        "mellow-theme/mellow.nvim",
        priority = 1000,
    },

    -- Set default colorscheme (load after all theme plugins)
    {
        "default-colorscheme",
        dir = vim.fn.stdpath("config"),
        priority = 999,
        config = function()
            vim.cmd.colorscheme("catppuccin-mocha")
        end,
    },
}
