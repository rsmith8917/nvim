-- ============================================================================
-- KEY MAPPINGS
-- ============================================================================

local M = {}

function M.setup()
    -- Core
    vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save file" })
    vim.keymap.set("n", "<leader>q", "<cmd>qa!<CR>", { desc = "Quit all (force)" })
    vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

    -- Buffers
    vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
    vim.keymap.set("n", "<leader>bd", function()
        require("mini.bufremove").delete(0, false)
    end, { desc = "Delete buffer" })
    vim.keymap.set("n", "<leader>bD", function()
        require("mini.bufremove").delete(0, true)
    end, { desc = "Delete buffer (force)" })

    -- Windows
    vim.keymap.set("n", "<leader>\\", "<C-w>v<C-w>l", { desc = "Split vertically" })
    vim.keymap.set("n", "<leader>-", "<C-w>s<C-w>j", { desc = "Split horizontally" })
    vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Focus left" })
    vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Focus right" })
    vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Focus down" })
    vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Focus up" })
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
    end, { desc = "Close window" })

    -- LSP
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
    vim.keymap.set("n", "gh", vim.diagnostic.open_float, { desc = "Show diagnostics" })
    vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { desc = "Code action" })
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
    vim.keymap.set("n", "<leader>F", function()
        require("conform").format({ async = true, lsp_fallback = true })
    end, { desc = "Format buffer" })

    -- Telescope
    vim.keymap.set("n", "<leader>ff", function()
        require("telescope.builtin").find_files()
    end, { desc = "Find files" })
    vim.keymap.set("n", "<leader><leader>", function()
        require("telescope.builtin").find_files()
    end, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", function()
        require("telescope.builtin").live_grep()
    end, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", function()
        require("telescope.builtin").buffers()
    end, { desc = "Find buffers" })
    vim.keymap.set("n", "<leader>fh", function()
        require("telescope.builtin").help_tags()
    end, { desc = "Help tags" })
    vim.keymap.set("n", "<leader>fF", function()
        require("telescope.builtin").find_files({ hidden = true, no_ignore = true, follow = true })
    end, { desc = "Find all files" })
    vim.keymap.set("n", "<leader>fG", function()
        require("telescope.builtin").live_grep({
            additional_args = function(_)
                return { "--hidden", "--no-ignore" }
            end,
        })
    end, { desc = "Live grep all" })

    -- Neo-tree
    vim.keymap.set("n", "<leader>e", function()
        require("neo-tree.command").execute({
            source = "filesystem",
            toggle = true,
            dir = vim.loop.cwd(),
        })
    end, { desc = "Toggle file explorer" })

    -- Git
    vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open LazyGit" })

    -- Harpoon
    vim.keymap.set("n", "<leader>a", function()
        local harpoon = require("harpoon")
        harpoon:list():add()
    end, { desc = "Add to Harpoon" })
    vim.keymap.set("n", "<leader>m", function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon menu" })
    vim.keymap.set("n", "<leader>1", function()
        require("harpoon"):list():select(1)
    end, { desc = "Harpoon file 1" })
    vim.keymap.set("n", "<leader>2", function()
        require("harpoon"):list():select(2)
    end, { desc = "Harpoon file 2" })
    vim.keymap.set("n", "<leader>3", function()
        require("harpoon"):list():select(3)
    end, { desc = "Harpoon file 3" })
    vim.keymap.set("n", "<leader>4", function()
        require("harpoon"):list():select(4)
    end, { desc = "Harpoon file 4" })
    vim.keymap.set("n", "<leader>5", function()
        require("harpoon"):list():select(5)
    end, { desc = "Harpoon file 5" })

    -- Illuminate
    vim.keymap.set("n", "<C-n>", function()
        require("illuminate").goto_next_reference(false)
    end, { desc = "Next reference" })
    vim.keymap.set("n", "<C-p>", function()
        require("illuminate").goto_prev_reference(false)
    end, { desc = "Previous reference" })

    -- Folding
    vim.keymap.set("n", "-", "za", { desc = "Toggle fold" })
    vim.keymap.set("n", "zo", "zO", { desc = "Open fold recursively" })
    vim.keymap.set("n", "zc", "zC", { desc = "Close fold recursively" })
    vim.keymap.set("n", "zO", function()
        require("ufo").openAllFolds()
    end, { desc = "Open all folds" })
    vim.keymap.set("n", "zC", function()
        require("ufo").closeAllFolds()
    end, { desc = "Close all folds" })
    vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end, { desc = "Peek fold/hover" })

    -- Coverage
    vim.keymap.set("n", "<leader>cc", function()
        require("coverage").toggle()
    end, { desc = "Toggle coverage display" })
    vim.keymap.set("n", "<leader>cs", function()
        require("coverage").summary()
    end, { desc = "Show coverage summary" })
    vim.keymap.set("n", "<leader>cl", function()
        require("coverage").load(true)
    end, { desc = "Load/reload coverage" })
end

return M