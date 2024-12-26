local pylsp_settings = {
    pylsp = {
        plugins = {
            jedi_completion = {
                enabled = true,
                include_params = true,
                eager = false,
                fuzzy = true,
                -- cache_for = { "numpy", "scipy" },
            },
            jedi_definition = {
                enabled = true,
                follow_imports = true,
                follow_builtin_imports = true,
            },
            jedi_hover = { enabled = true },
            jedi_references = { enabled = true },
            jedi_signature_help = { enabled = true },
            jedi_symbols = {
                enabled = true,
                all_scopes = true,
                include_import_symbols = true,
            },
            --
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            pylint = { enabled = false, executable = "pylint" },
            flake8 = { enabled = false },
            yapf = { enabled = false },
            autopep8 = { enabled = false },
            rope_autoimport = { enabled = false },
            black = { enabled = true },
        },
    },
}

local html_settings = {
    init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
            css = true,
            javascript = true,
        },
        provideFormatter = true,
    },
}

local eslint_settings = {
    settings = {
        -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
        workingDirectories = { mode = "auto" },
    },
}

return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function(_, opts)
            -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- blink supports additional completion capabilities, so broadcast that to servers
            --
            -- NOTE: возможно, ломает goto definition в ruff
            -- capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

            -- capabilities.offsetEncoding = { 'utf-16' }

            lspconfig.ruff.setup({
                init_options = {
                    settings = {
                        lint = {
                            preview = true,
                        },
                        format = {
                            preview = true,
                        },
                        organizeImports = true,
                    },
                },
            })
            lspconfig.pylsp.setup({
                settings = pylsp_settings,
                flags = {
                    debounce_text_changes = 50,
                },
            })

            lspconfig.html.setup(html_settings)

            lspconfig.eslint.setup(eslint_settings)

            lspconfig.quick_lint_js.setup({})

            lspconfig.ts_ls.setup({})

            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            disable = { "missing-fields", "incomplete-signature-doc", "undefined-doc-name" },
                            unusedLocalExclude = { "_*" },
                        },
                    },
                },
            })

            for server, config in pairs(opts.servers) do
                -- passing config.capabilities to blink.cmp merges with the capabilities in your
                -- `opts[server].capabilities, if you've defined it
                config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end
        end,
    },
}
