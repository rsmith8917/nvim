-- ============================================================================
-- FILE NAVIGATION
-- ============================================================================

return {
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
                    follow_current_file = {
                        enabled = false,
                    },
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

    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                -- Manual mode: only change directory when explicitly using Telescope, not automatically
                manual_mode = true,

                -- Detection methods to use
                detection_methods = { "pattern", "lsp" },

                -- Patterns to detect project root
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "go.mod", "Cargo.toml" },

                -- Don't calculate root directory on specific directories
                exclude_dirs = {},

                -- Show hidden files in telescope
                show_hidden = false,

                -- When set to false, you will get a message when project.nvim changes your directory
                silent_chdir = true,

                -- Path where project.nvim will store the project history
                datapath = vim.fn.stdpath("data"),
            })

            -- Enable telescope integration
            require('telescope').load_extension('projects')
        end,
    },
}
