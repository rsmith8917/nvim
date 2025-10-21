-- ============================================================================
-- NEOVIM CONFIGURATION
-- ============================================================================

-- Core settings, autocommands, and diagnostics
require("core").setup()

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins")

-- Load keymaps (after plugins to ensure plugin functions are available)
require("core.keymaps").setup()