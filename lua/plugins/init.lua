-- ============================================================================
-- PLUGIN LOADER
-- ============================================================================
--
-- This file loads all plugin specifications from modular files.
-- Each category of plugins is organized in its own file for better
-- maintainability and organization.

return {
    -- Load all plugin modules
    { import = "plugins.treesitter" },
    { import = "plugins.telescope" },
    { import = "plugins.lsp" },
    { import = "plugins.formatting" },
    { import = "plugins.colorschemes" },
    { import = "plugins.ui" },
    { import = "plugins.navigation" },
    { import = "plugins.editing" },
    { import = "plugins.coverage" },
    { import = "plugins.markdown" },
    { import = "plugins.notebooks" },
    { import = "plugins.openapi" },
}
