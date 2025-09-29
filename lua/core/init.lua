-- ============================================================================
-- CORE SETTINGS
-- ============================================================================

local M = {}

function M.setup()
    -- Leader keys
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
    vim.opt.scrolloff = 12
    vim.opt.sidescrolloff = 8

    -- Buffer settings (for mini.bufremove)
    vim.opt.confirm = true
    vim.opt.hidden = true

    -- Disable netrw (using Neo-tree instead)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Folding settings (for ufo)
    vim.o.foldcolumn = "0"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸]]

    -- Terminal title
    vim.opt.title = true
    vim.opt.titlestring = "nvim: %{fnamemodify(getcwd(), ':t')}"

    -- Setup autocommands
    M.setup_autocommands()

    -- Setup diagnostics
    M.setup_diagnostics()

    -- Setup user commands
    M.setup_commands()
end

function M.setup_autocommands()
    -- Highlight on yank
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank({
                higroup = "Search",
                timeout = 300,
            })
        end,
    })

    -- Auto-close utility windows with 'q'
    vim.api.nvim_create_autocmd("FileType", {
        pattern = {
            "help",
            "man",
            "qf",
            "lspinfo",
            "checkhealth",
            "startuptime",
            "spectre_panel",
            "tsplayground",
            "dap-float",
            "neo-tree",
        },
        callback = function(ev)
            vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
        end,
    })

    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
            require("conform").format({ bufnr = args.buf, lsp_fallback = true })
        end,
    })
end

function M.setup_diagnostics()
    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "✘",
                [vim.diagnostic.severity.WARN] = "▲",
                [vim.diagnostic.severity.INFO] = "ⓘ",
                [vim.diagnostic.severity.HINT] = "💡",
            },
        },
    })
end

function M.setup_commands()
    -- Safe window close command
    vim.api.nvim_create_user_command("Q", function()
        local only_tab = #vim.api.nvim_list_tabpages() == 1
        local only_win = #vim.api.nvim_list_wins() == 1
        if not (only_tab and only_win) then
            vim.cmd("close")
            return
        end
        local newbuf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_set_current_buf(newbuf)
        vim.bo[newbuf].buftype = ""
        vim.bo[newbuf].bufhidden = "hide"
        vim.bo[newbuf].swapfile = false
        vim.api.nvim_buf_set_lines(newbuf, 0, -1, false, { "" })
    end, {})
end

return M