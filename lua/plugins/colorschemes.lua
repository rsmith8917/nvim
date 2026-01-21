-- ============================================================================
-- COLORSCHEMES
-- ============================================================================

return {
    {
        "jesseleite/nvim-noirbuddy",
        dependencies = { "tjdevries/colorbuddy.nvim" },
        lazy = false,
        priority = 1000,
        config = function()
            require("noirbuddy").setup({
                -- preset = "crt-green", -- options: minimal, miami-nights, kiwi, slate, crt-green, crt-amber
                colors = {
                    primary = "#8fc490",
                    diagnostic_error = "#e08080",
                    diagnostic_info = "#80b8e0",
                    diagnostic_warning = "#e0d580",
                    diagnostic_hint = "#c380e0",
                    diff_add = "#a0c4a0",
                    diff_delete = "#c49090",
                    diff_change = "#c4c0a0",
                },
            })

            local colorbuddy = require("colorbuddy")
            local Group = colorbuddy.Group
            local colors = colorbuddy.colors
            Group.new("NeoTreeGitModified", colors.primary)
            Group.new("NeoTreeGitAdded", colors.primary)
            Group.new("NeoTreeGitDeleted", colors.noir_5)
            Group.new("NeoTreeGitConflict", colors.diagnostic_error)
            Group.new("NeoTreeGitUntracked", colors.noir_1)
        end,
    },
}
