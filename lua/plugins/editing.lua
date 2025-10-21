-- ============================================================================
-- EDITING ENHANCEMENTS
-- ============================================================================

return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            {
                "<leader>xd",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",     desc = "Location List (Trouble)" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",      desc = "Quickfix List (Trouble)" },
        },
        config = function()
            require("trouble").setup()
        end,
    },

    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
            { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
        },
        config = function()
            require("Comment").setup()
        end,
    },

    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("ibl").setup({
                indent = { char = "▏" },
                scope = { enabled = false },
            })
        end,
    },

    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("illuminate").configure({
                delay = 200,
                large_file_cutoff = 2000,
                large_file_overrides = {
                    providers = { "lsp" },
                },
                providers = {
                    "lsp",
                    "treesitter",
                    "regex",
                },
                filetypes_denylist = {
                    "dirvish",
                    "fugitive",
                    "neo-tree",
                    "alpha",
                    "NvimTree",
                    "packer",
                    "lazy",
                    "TelescopePrompt",
                },
                under_cursor = true,
                min_count_to_highlight = 2,
            })
        end,
    },

    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end,
                preview = {
                    win_config = {
                        border = "rounded",
                        winblend = 0,
                    },
                },
            })
        end,
    },

    {
        "echasnovski/mini.bufremove",
        version = false,
        event = "VeryLazy",
    },
}
