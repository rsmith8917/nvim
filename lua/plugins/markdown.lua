-- ============================================================================
-- MARKDOWN RENDERING
-- ============================================================================

return {
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
