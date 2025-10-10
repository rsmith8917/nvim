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
                    "c",
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

            -- C/C++
            lspconfig.clangd.setup({
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

    -- UI ENHANCEMENTS
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    -- Disable noice for LSP hover and signature to avoid conflicts
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                        ["vim.lsp.util.stylize_markdown"] = false,
                        ["cmp.entry.get_documentation"] = false,
                    },
                    hover = {
                        enabled = false,
                    },
                    signature = {
                        enabled = false,
                    },
                    message = {
                        enabled = false,
                    },
                    documentation = {
                        view = false,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false,       -- add a border to hover docs and signature help
                },
                cmdline = {
                    enabled = true,         -- enables the Noice cmdline UI
                    view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` for classic cmdline
                    opts = {},              -- global options for the cmdline. See section on views
                    format = {
                        -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
                        -- view: (default is cmdline view)
                        -- opts: any options passed to the view
                        -- icon_hl_group: optional hl_group for the icon
                        cmdline = { pattern = "^:", icon = "", lang = "vim" },
                        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
                        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
                        input = {}, -- Used by input()
                    },
                },
                messages = {
                    enabled = true,              -- enables the Noice messages UI
                    view = "notify",             -- default view for messages
                    view_error = "notify",       -- view for errors
                    view_warn = "notify",        -- view for warnings
                    view_history = "messages",   -- view for :messages
                    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
                },
                popupmenu = {
                    enabled = true,  -- enables the Noice popupmenu UI
                    backend = "nui", -- backend to use to show regular cmdline completions
                },
                notify = {
                    enabled = true,
                    view = "notify",
                },
                views = {
                    cmdline_popup = {
                        position = {
                            row = 5,
                            col = "50%",
                        },
                        size = {
                            width = 60,
                            height = "auto",
                        },
                    },
                    popupmenu = {
                        relative = "editor",
                        position = {
                            row = 8,
                            col = "50%",
                        },
                        size = {
                            width = 60,
                            height = 10,
                        },
                        border = {
                            style = "rounded",
                            padding = { 0, 1 },
                        },
                        win_options = {
                            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                        },
                    },
                },
                routes = {
                    {
                        filter = {
                            event = "msg_show",
                            kind = "",
                            find = "written",
                        },
                        opts = { skip = true },
                    },
                    -- Skip certain LSP progress messages
                    {
                        filter = {
                            event = "lsp",
                            kind = "progress",
                        },
                        opts = { skip = true },
                    },
                },
            })
        end,
    },

    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
                fps = 60,
                icons = {
                    DEBUG = "",
                    ERROR = "",
                    INFO = "",
                    TRACE = "✎",
                    WARN = ""
                },
                level = 2,
                minimum_width = 50,
                render = "compact",
                stages = "fade_in_slide_out",
                timeout = 3000,
                top_down = false
            })
        end,
    },

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
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        config = function()
            require("onedarkpro").setup({
                options = {
                    transparency = false,
                    terminal_colors = true,
                    highlight_inactive_windows = false,
                },
            })
        end,
    },

    {
        "nyoom-engineering/oxocarbon.nvim",
        priority = 1000,
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

    -- Set default colorscheme (load after all theme plugins)
    {
        "default-colorscheme",
        dir = vim.fn.stdpath("config"),
        priority = 999,
        config = function()
            vim.cmd.colorscheme("catppuccin-mocha")
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
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "filename",
                            path = 1, -- 0: just filename, 1: relative path, 2: absolute path
                        },
                    },
                    lualine_x = { "filetype" },
                    lualine_y = {},
                    lualine_z = {},
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
                    search = false,
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

    -- GIT INTEGRATION
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            vim.g.lazygit_floating_window_use_plenary = 1
        end,
    },

    -- CODE COVERAGE
    {
        "andythigpen/nvim-coverage",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("coverage").setup({
                auto_reload = true,
                load_coverage_cb = function(ftype)
                    vim.notify("Loaded " .. ftype .. " coverage")
                end,
                commands = true, -- create commands
                highlights = {
                    -- customize highlight groups created by the plugin
                    covered = { fg = "#b1e4a3" },   -- light green for covered lines
                    uncovered = { fg = "#ff7070" }, -- light red for uncovered lines
                    partial = { fg = "#ffdf87" },   -- light yellow for partially covered
                },
                signs = {
                    -- use signs to show coverage
                    covered = { hl = "CoverageCovered", text = "▎" },
                    uncovered = { hl = "CoverageUncovered", text = "▎" },
                    partial = { hl = "CoveragePartial", text = "▎" },
                },
                summary = {
                    -- customize the summary popup
                    min_coverage = 80.0,
                },
                lang = {
                    -- customize per-language settings
                    python = {
                        coverage_command = "coverage json --fail-under=0 -q -o -",
                    },
                    javascript = {
                        coverage_file = "coverage/lcov.info",
                    },
                    typescript = {
                        coverage_file = "coverage/lcov.info",
                    },
                    go = {
                        coverage_file = "coverage.out",
                    },
                },
            })
        end,
    },

    -- MARKDOWN RENDERING
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ft = { "markdown" },
        config = function()
            require("render-markdown").setup({
                -- Headings with different background colors
                heading = {
                    enabled = true,
                    sign = false,
                    icons = { "", "", "", "", "", "" },
                },
                -- Code blocks with background
                code = {
                    enabled = true,
                    sign = false,
                    style = "full",
                    left_pad = 2,
                    right_pad = 2,
                },
                -- Checkboxes
                checkbox = {
                    enabled = true,
                    unchecked = { icon = "󰄱 " },
                    checked = { icon = "󰱒 " },
                },
                -- Bullet points
                bullet = {
                    enabled = true,
                    icons = { "●", "○", "◆", "◇" },
                },
                -- Quote blocks
                quote = {
                    enabled = true,
                    icon = "",
                },
                -- Pipe tables
                pipe_table = {
                    enabled = true,
                    style = "full",
                },
            })
        end,
    },
}
