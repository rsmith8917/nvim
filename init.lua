-- ==============================
--   Basic Configuration
-- ==============================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Editor options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

-- Disable netrw (using Neo-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank {
            higroup = "Search",
            timeout = 300,
        }
    end,
})

-- Diagnostic signs (using new API)
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.INFO] = "ⓘ",
            [vim.diagnostic.severity.HINT] = "💡",
        }
    }
})



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

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
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
                sync_install = false,
                auto_install = true,

                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
        },
        cmd = "Telescope",
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    -- Default ignore patterns
                    file_ignore_patterns = {
                        "%.git/", "node_modules/", "dist/", "build/", "coverage/", "target/",
                        "bin/", "obj/", "%.venv/", "venv/", "%.cache/", "android/", "ios/", "Pods/",
                    },
                    -- Ripgrep configuration
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
                    -- Default picker settings
                    find_files = {
                        hidden = false,
                        no_ignore = false,
                        follow = true,
                    },
                    live_grep = {
                        -- Additional grep filters
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


    -- Lualine
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

    -- LSP
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

    -- Completion
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

    -- Formatting
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
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
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

    -- Buffer Management
    {
        "echasnovski/mini.bufremove",
        version = false,
        event = "VeryLazy",
        config = function()
            vim.opt.confirm = true
            vim.opt.hidden = true

            -- Safe window close function
            local function safe_close_window()
                local only_tab = #vim.api.nvim_list_tabpages() == 1
                local only_win = #vim.api.nvim_list_wins() == 1
                if not (only_tab and only_win) then
                    vim.cmd("close")
                    return
                end
                -- Create scratch buffer instead of quitting
                local newbuf = vim.api.nvim_create_buf(true, false)
                vim.api.nvim_set_current_buf(newbuf)
                vim.bo[newbuf].buftype = ""
                vim.bo[newbuf].bufhidden = "hide"
                vim.bo[newbuf].swapfile = false
                vim.api.nvim_buf_set_lines(newbuf, 0, -1, false, { "" })
            end


            -- Auto-close utility windows with 'q'
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help", "man", "qf", "lspinfo", "checkhealth", "startuptime",
                    "spectre_panel", "tsplayground", "dap-float", "neo-tree",
                },
                callback = function(ev)
                    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
                end,
            })

            -- Create :Q command
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

    -- Neo-tree
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
            vim.g.lazygit_floating_window_use_plenary = 1
        end,
    },

    -- Harpoon for quick file navigation
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
        end,
    },

    -- Highlight references under cursor
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
                    'lsp',
                    'treesitter',
                    'regex',
                },
                filetypes_denylist = {
                    'dirvish',
                    'fugitive',
                    'neo-tree',
                    'alpha',
                    'NvimTree',
                    'packer',
                    'lazy',
                    'TelescopePrompt',
                },
                under_cursor = true,
                min_count_to_highlight = 2,
            })
        end,
    },

    -- Simple scrollbar with diagnostic indicators
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

    -- Code folding
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- Set folding options
            vim.o.foldcolumn = '1'
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.o.fillchars = [[eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸]]

            require('ufo').setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
                end,
                preview = {
                    win_config = {
                        border = 'rounded',
                        winblend = 0,
                    },
                },
            })
        end,
    }
})

-- ==============================
--   Keymaps
-- ==============================

-- Core
vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Windows
vim.keymap.set("n", "<leader>\\", "<C-w>v<C-w>l", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>-", "<C-w>s<C-w>j", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Focus left window" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Focus right window" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Focus below window" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Focus above window" })

-- LSP
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

-- Telescope
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader><leader>", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })

-- Telescope (all files)
vim.keymap.set("n", "<leader>fF", function()
    require("telescope.builtin").find_files({ hidden = true, no_ignore = true, follow = true })
end, { desc = "Find files (ALL)" })
vim.keymap.set("n", "<leader>fG", function()
    require("telescope.builtin").live_grep({
        additional_args = function(_) return { "--hidden", "--no-ignore" } end,
    })
end, { desc = "Live grep (ALL)" })

-- Neo-tree
vim.keymap.set("n", "<leader>e", function()
    require("neo-tree.command").execute({
        source = "filesystem",
        toggle = true,
        dir = vim.loop.cwd(),
    })
end, { desc = "Toggle Neo-tree" })

-- Git
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open Lazygit" })

-- Harpoon
vim.keymap.set("n", "<leader>a", function() 
    local harpoon = require("harpoon")
    harpoon:list():add()
end, { desc = "Add file to Harpoon" })
vim.keymap.set("n", "<leader>m", function()
    local harpoon = require("harpoon")
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle Harpoon menu" })
vim.keymap.set("n", "<leader>1", function() require("harpoon"):list():select(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() require("harpoon"):list():select(2) end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() require("harpoon"):list():select(3) end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() require("harpoon"):list():select(4) end, { desc = "Harpoon file 4" })
vim.keymap.set("n", "<leader>5", function() require("harpoon"):list():select(5) end, { desc = "Harpoon file 5" })

-- Illuminate navigation
vim.keymap.set("n", "<C-n>", function() require("illuminate").goto_next_reference(false) end, { desc = "Next reference" })
vim.keymap.set("n", "<C-p>", function() require("illuminate").goto_prev_reference(false) end,
    { desc = "Previous reference" })

-- Folding
vim.keymap.set("n", "-", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "zo", "zO", { desc = "Open fold recursively" })
vim.keymap.set("n", "zc", "zC", { desc = "Close fold recursively" })
vim.keymap.set("n", "zO", function() require("ufo").openAllFolds() end, { desc = "Open ALL folds in file" })
vim.keymap.set("n", "zC", function() require("ufo").closeAllFolds() end, { desc = "Close ALL folds in file" })
vim.keymap.set("n", "K", function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then
        vim.lsp.buf.hover()
    end
end, { desc = "Peek fold or hover" })

-- Buffer management
vim.keymap.set("n", "<leader>w", function()
    local only_tab = #vim.api.nvim_list_tabpages() == 1
    local only_win = #vim.api.nvim_list_wins() == 1
    if not (only_tab and only_win) then
        vim.cmd("close")
        return
    end
    -- Create scratch buffer instead of quitting
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
