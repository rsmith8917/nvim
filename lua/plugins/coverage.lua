-- ============================================================================
-- CODE COVERAGE
-- ============================================================================

return {
    {
        "andythigpen/nvim-coverage",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("coverage").setup({
                auto_reload = true,
                load_coverage_cb = function(ftype)
                    vim.notify("Loaded " .. ftype .. " coverage")
                end,
                commands = true, -- create commands
                highlights = {
                    -- customize highlight groups created by the plugin
                    covered = { fg = "#b1e4a3" },   -- light green for covered lines
                    uncovered = { fg = "#ff7070" }, -- light red for uncovered lines
                    partial = { fg = "#ffdf87" },   -- light yellow for partially covered
                },
                signs = {
                    -- use signs to show coverage
                    covered = { hl = "CoverageCovered", text = "▎" },
                    uncovered = { hl = "CoverageUncovered", text = "▎" },
                    partial = { hl = "CoveragePartial", text = "▎" },
                },
                summary = {
                    -- customize the summary popup
                    min_coverage = 80.0,
                },
                lang = {
                    -- customize per-language settings
                    python = {
                        coverage_command = "coverage json --fail-under=0 -q -o -",
                    },
                    javascript = {
                        coverage_file = "coverage/lcov.info",
                    },
                    typescript = {
                        coverage_file = "coverage/lcov.info",
                    },
                    go = {
                        coverage_file = "coverage.out",
                    },
                },
            })
        end,
    },
}
