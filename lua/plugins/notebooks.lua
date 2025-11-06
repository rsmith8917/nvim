-- ============================================================================
-- JUPYTER NOTEBOOK PLUGINS
-- ============================================================================
--
-- Plugins for editing and working with Jupyter notebooks (.ipynb files)

return {
	-- Jupytext: Edit Jupyter notebooks as plain text files
	-- Automatically converts .ipynb to Python format on open and back on save
	{
		"GCBallesteros/jupytext.nvim",
		opts = {
			-- Default format for conversion (percent is Python script with cell markers)
			-- Options: "percent", "markdown", "python", "auto"
			style = "percent",

			-- Output format configuration
			output_extension = "auto", -- Use the same extension as input
			force_ft = nil, -- Automatically detect filetype

			-- Custom format options passed to jupytext
			-- See: https://jupytext.readthedocs.io/en/latest/formats.html
			custom_language_formatting = {},
		},
		lazy = false, -- Load on startup to handle .ipynb files
		config = true,
	},
}
