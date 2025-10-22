-- ============================================================================
-- FUZZY FINDER
-- ============================================================================

return {
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
            "nvim-telescope/telescope-file-browser.nvim",
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
                    file_browser = {
                        theme = "ivy",
                        hijack_netrw = false,
                        grouped = true,
                        hidden = true,
                    },
                },
            })

            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "file_browser")
        end,
    },
}
