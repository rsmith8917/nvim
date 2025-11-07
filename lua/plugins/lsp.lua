-- ============================================================================
-- LSP & AUTOCOMPLETION
-- ============================================================================

return {
    -- LSP CONFIGURATION
    {
        "neovim/nvim-lspconfig",
        config = function()
            local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Set global LSP configuration with cmp capabilities
            vim.lsp.config('*', {
                capabilities = cmp_capabilities,
            })

            -- Lua with custom settings
            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            -- YAML with OpenAPI schema support
            vim.lsp.config('yamlls', {
                settings = {
                    yaml = {
                        schemas = {
                            ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = {
                                "openapi.yaml",
                                "openapi.yml",
                                "**/openapi/**/*.yaml",
                                "**/openapi/**/*.yml",
                            },
                            ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.json"] = {
                                "**/swagger/**/*.yaml",
                                "**/swagger/**/*.yml",
                            },
                        },
                        format = {
                            enable = true,
                        },
                        validate = true,
                        completion = true,
                    },
                },
            })

            -- Enable all LSP servers
            vim.lsp.enable({
                'lua_ls',
                'gopls',
                'ts_ls',
                'pyright',
                'clangd',
                'yamlls',
            })
        end,
    },

    -- AUTOCOMPLETION
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },
}
