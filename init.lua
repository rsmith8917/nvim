-- ==============================
--   Basic Neovim Configuration
-- ==============================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus" -- use the system clipboard

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank {
            higroup = "Search", -- highlight group to use
            timeout = 300,      -- time in ms before it fades
        }
    end,
})

-- Keymaps will be set up after plugins are loaded


-- ==============================
--   Bootstrap lazy.nvim
-- ==============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ==============================
--   Plugins
-- ==============================
require("lazy").setup({

    -- Treesitter: syntax highlighting & indentation
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- Install these parsers automatically
                ensure_installed = {
                    "go",
                    "lua",
                    "python",
                    "javascript",
                    "typescript",
                    "tsx",
                    "css",
                    "html",
                    "bash",
                    "json",
                    "yaml",
                    "markdown",
                },
                sync_install = false, -- install in background
                auto_install = true,  -- auto-install missing parsers when opening a file

                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Telescope: fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Fast native sorter
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
        },
        cmd = "Telescope",
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    -- Keep noisy dirs out by default (still overridable with the ALL mappings)
                    file_ignore_patterns = {
                        "%.git/", "node_modules/", "dist/", "build/", "coverage/", "target/",
                        "bin/", "obj/", "%.venv/", "venv/", "%.cache/", "android/", "ios/", "Pods/",
                    },
                    -- Ripgrep args for live_grep/grep_string
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden", -- allow hidden files… (still filtered by file_ignore_patterns and .gitignore)
                        -- (we DO NOT pass --no-ignore here so defaults respect .gitignore)
                    },
                    path_display = { "truncate" },
                    mappings = {
                        i = {
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<Esc>"] = actions.close,
                        },
                    },
                },
                pickers = {
                    -- Sensible defaults; “ALL” mappings override these per-call
                    find_files = {
                        hidden = false,
                        no_ignore = false,
                        follow = true, -- follow symlinks
                    },
                    live_grep = {
                        -- Extra safety filters for default grep to avoid heavy trees
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
                extensions = { fzf = { fuzzy = true, case_mode = "smart_case" } },
            })

            pcall(telescope.load_extension, "fzf")
        end,
    },

    -- Spectre: Project-wide Search/Replace
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Lualine: statusline
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

    -- LSP Config
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Lua
            lspconfig.lua_ls.setup({
                capabilities = cmp_capabilities,
                settings = {
                    Lua = { diagnostics = { globals = { "vim" } } },
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

    -- Autocompletion
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

    -- Conform (auto formatting)
    {
        "stevearc/conform.nvim",
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    go = { "gofmt" },
                    lua = { "stylua" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" }, -- JSX
                    typescriptreact = { "prettier" }, -- TSX
                    python = { "black" },
                    json = { "prettier" },
                    css = { "prettier" },
                    html = { "prettier" },
                    yaml = { "prettier" }
                },
            })

            -- Format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function(args)
                    conform.format({ bufnr = args.buf, lsp_fallback = true })
                end,
            })
        end,
    },

    -- Buffer and Window closing
    {
        "echasnovski/mini.bufremove",
        version = false,
        event = "VeryLazy",
        config = function()
            -- Sensible options so you can close/switch freely
            vim.opt.confirm = true -- prompt to save on close
            vim.opt.hidden = true  -- allow modified buffers in background

            -- Safe window closer: never exit Neovim unless you explicitly :qa!
            local function safe_close_window()
                local only_tab = #vim.api.nvim_list_tabpages() == 1
                local only_win = #vim.api.nvim_list_wins() == 1
                if not (only_tab and only_win) then
                    vim.cmd("close")
                    return
                end
                -- Last window of last tab → create a scratch buffer instead of quitting
                local newbuf = vim.api.nvim_create_buf(true, false)
                vim.api.nvim_set_current_buf(newbuf)
                vim.bo[newbuf].buftype = "" -- normal buffer
                vim.bo[newbuf].bufhidden = "hide"
                vim.bo[newbuf].swapfile = false
                vim.api.nvim_buf_set_lines(newbuf, 0, -1, false, { "" })
            end

            -- Keymaps moved to consolidated section at end of file

            -- Make `q` close helper/utility windows
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help", "man", "qf", "lspinfo", "checkhealth", "startuptime",
                    "spectre_panel", "tsplayground", "dap-float", "neo-tree",
                },
                callback = function(ev)
                    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
                end,
            })

            -- Optional: a :Q that behaves like our safe window close
            vim.api.nvim_create_user_command("Q", safe_close_window, {})
        end,
    },
    -- Colorscheme
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

    -- Neo-tree: File Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
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
                },
            })
        end,
    },

    -- LazyGit
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            -- optional: always open in a floating window
            vim.g.lazygit_floating_window_use_plenary = 1
        end,
    }
})

-- ==============================
--   Keymaps
-- ==============================

-- Core editor keymaps
vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save file" })

-- Buffer navigation
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Window splits and navigation
vim.keymap.set("n", "<leader>\\", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Focus left window" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Focus right window" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Focus below window" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Focus above window" })

-- LSP keymaps
vim.keymap.set("n", "gh", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Formatting
vim.keymap.set("n", "<leader>F", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Telescope: file finding and search
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })

-- Telescope: search everything (overrides ignore)
vim.keymap.set("n", "<leader>fF", function()
    require("telescope.builtin").find_files({ hidden = true, no_ignore = true, follow = true })
end, { desc = "Find files (ALL)" })
vim.keymap.set("n", "<leader>fG", function()
    require("telescope.builtin").live_grep({
        additional_args = function(_) return { "--hidden", "--no-ignore" } end,
    })
end, { desc = "Live grep (ALL)" })

-- Spectre: search and replace
vim.keymap.set("n", "<leader>sr", function() require("spectre").toggle() end, { desc = "Search & Replace" })
vim.keymap.set("n", "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end,
    { desc = "Search current word" })
vim.keymap.set("n", "<leader>sf", function() require("spectre").open_file_search() end,
    { desc = "Search in current file" })

-- Neo-tree: file explorer
vim.keymap.set("n", "<leader>e", function()
    require("neo-tree.command").execute({
        source = "filesystem",
        toggle = true,
        dir = vim.loop.cwd(),
    })
end, { desc = "Toggle Neo-tree" })

-- LazyGit: git interface
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open Lazygit" })

-- Buffer management (mini.bufremove keymaps from plugin config)
vim.keymap.set("n", "<leader>w", function()
    local only_tab = #vim.api.nvim_list_tabpages() == 1
    local only_win = #vim.api.nvim_list_wins() == 1
    if not (only_tab and only_win) then
        vim.cmd("close")
        return
    end
    -- Last window of last tab → create a scratch buffer instead of quitting
    local newbuf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(newbuf)
    vim.bo[newbuf].buftype = ""
    vim.bo[newbuf].bufhidden = "hide"
    vim.bo[newbuf].swapfile = false
    vim.api.nvim_buf_set_lines(newbuf, 0, -1, false, { "" })
end, { desc = "Close window (no quit)" })

vim.keymap.set("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer (keep window)" })

vim.keymap.set("n", "<leader>bD", function()
    require("mini.bufremove").delete(0, true)
end, { desc = "Delete buffer (force, keep window)" })

vim.keymap.set("n", "<leader>q", "<cmd>qa!<CR>", { desc = "Quit ALL (!)" })
