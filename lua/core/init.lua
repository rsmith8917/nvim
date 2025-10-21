-- ============================================================================
-- CORE SETTINGS
-- ============================================================================

local M = {}

-- ============================================================================
-- UTILITIES
-- ============================================================================

-- Creates a scratch buffer instead of closing Neovim when closing last window
function M.safe_window_close()
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
end

-- ============================================================================
-- SETUP
-- ============================================================================

function M.setup()
    -- Leader keys
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    -- Editor behavior
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    vim.opt.cursorline = true
    vim.opt.scrolloff = 16
    vim.opt.sidescrolloff = 8
    vim.opt.cmdheight = 0

    -- System integration
    vim.opt.clipboard = "unnamedplus"
    vim.opt.termguicolors = true
    vim.opt.title = true
    vim.opt.titlestring = "nvim: %{fnamemodify(getcwd(), ':t')}"

    -- Buffer behavior
    vim.opt.confirm = true
    vim.opt.hidden = true

    -- Disable netrw (using Neo-tree)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Folding (for nvim-ufo)
    vim.o.foldcolumn = "0"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸]]

    M.setup_autocommands()
    M.setup_diagnostics()
    M.setup_commands()
end

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================

function M.setup_autocommands()
    -- Highlight yanked text briefly
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank({
                higroup = "Search",
                timeout = 300,
            })
        end,
    })

    -- Close utility windows with 'q'
    vim.api.nvim_create_autocmd("FileType", {
        pattern = {
            "help",
            "man",
            "qf",
            "lspinfo",
            "checkhealth",
            "neo-tree",
        },
        callback = function(ev)
            vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
        end,
    })

    -- Auto-format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
            local ok, conform = pcall(require, "conform")
            if ok then
                conform.format({ bufnr = args.buf, lsp_fallback = true })
            end
        end,
    })
end

-- ============================================================================
-- DIAGNOSTICS
-- ============================================================================

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

-- ============================================================================
-- USER COMMANDS
-- ============================================================================

function M.setup_commands()
    -- Safe window close - creates scratch buffer instead of quitting
    vim.api.nvim_create_user_command("Q", M.safe_window_close, {})
end

return M

