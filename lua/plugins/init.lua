-- ============================================================================
-- PLUGIN SPECIFICATIONS
-- ============================================================================

return {
    -- SYNTAX HIGHLIGHTING & PARSING
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "css",
                    "go",
                    "html",
                    "javascript",
                    "json",
                    "lua",
                    "markdown",
                    "python",
                    "tsx",
                    "typescript",
                    "yaml",
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- FUZZY FINDER
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = vim.fn.executable("make") == 1,
            },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    file_ignore_patterns = {
                        "%.git/",
                        "node_modules/",
                        "dist/",
                        "build/",
                        "coverage/",
                        "target/",
                        "bin/",
                        "obj/",
                        "%.venv/",
                        "venv/",
                        "%.cache/",
                        "android/",
                        "ios/",
                        "Pods/",
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--no-ignore-vcs",
                    },
                    path_display = { "truncate" },
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<Esc>"] = actions.close,
                        },
                        n = {
                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["q"] = actions.close,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        hidden = false,
                        no_ignore = false,
                        follow = true,
                    },
                    live_grep = {
                        additional_args = function(_)
                            return {
                                "--hidden",
                                "--glob=!.git/*",
                                "--glob=!node_modules/*",
                                "--glob=!dist/*",
                                "--glob=!build/*",
                                "--glob=!coverage/*",
                            }
                        end,
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        case_mode = "smart_case",
                    },
                },
            })

            pcall(telescope.load_extension, "fzf")
        end,
    },

    -- LSP CONFIGURATION
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Lua
            lspconfig.lua_ls.setup({
                capabilities = cmp_capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            -- Go
            lspconfig.gopls.setup({
                capabilities = cmp_capabilities,
            })

            -- TypeScript/JavaScript
            lspconfig.ts_ls.setup({
                capabilities = cmp_capabilities,
            })

            -- Python
            lspconfig.pyright.setup({
                capabilities = cmp_capabilities,
            })
        end,
    },

    -- AUTOCOMPLETION
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- CODE FORMATTING
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
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

    -- UI ENHANCEMENTS
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
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true,
                },
            })
        end,
    },

    {
        "petertriho/nvim-scrollbar",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("scrollbar").setup({
                show_in_active_only = false,
                hide_if_all_visible = true,
                throttle_ms = 100,
                handle = {
                    color = "#51576d",
                },
                marks = {
                    Search = { color = "#f9e2af" },
                    Error = { color = "#f38ba8" },
                    Warn = { color = "#fab387" },
                    Info = { color = "#89b4fa" },
                    Hint = { color = "#94e2d5" },
                    Misc = { color = "#cba6f7" },
                },
                handlers = {
                    cursor = true,
                    diagnostic = true,
                    search = true,
                },
                excluded_filetypes = {
                    "neo-tree",
                    "lazy",
                    "TelescopePrompt",
                },
            })
        end,
    },

    -- FILE NAVIGATION
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = true,
                    },
                },
                window = {
                    position = "left",
                    width = 40,
                    mappings = {
                        ["o"] = "system_open",
                    },
                },
                commands = {
                    system_open = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        local os_name = vim.loop.os_uname().sysname

                        if os_name == "Darwin" then
                            -- macOS: reveal in Finder
                            vim.fn.jobstart({ "open", "-R", path }, { detach = true })
                        elseif os_name == "Linux" then
                            -- Linux: open in file manager
                            vim.fn.jobstart({ "xdg-open", path }, { detach = true })
                        elseif os_name:match("Windows") then
                            -- Windows: open in Explorer
                            local p
                            local lastSlashIndex = path:match("^.+()\\[^\\]*$")
                            if lastSlashIndex then
                                p = path:sub(1, lastSlashIndex - 1)
                            else
                                p = path
                            end
                            vim.cmd("silent !start explorer " .. p)
                        end
                    end,
                },
            })
        end,
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
        end,
    },

    -- EDITING ENHANCEMENTS
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

    -- GIT INTEGRATION
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            vim.g.lazygit_floating_window_use_plenary = 1
        end,
    },
}