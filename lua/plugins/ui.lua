-- ============================================================================
-- UI ENHANCEMENTS
-- ============================================================================

return {
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
}
