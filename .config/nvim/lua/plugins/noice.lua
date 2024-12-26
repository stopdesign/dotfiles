-- Всплывающие уведомления
return {
    {
        "folke/noice.nvim",
        enabled = true,
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            cmdline = {
                enabled = true, -- enables the Noice cmdline UI
                view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
                opts = {}, -- global options for the cmdline. See section on views
                format = {
                    -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
                    -- view: (default is cmdline view)
                    -- opts: any options passed to the view
                    -- icon_hl_group: optional hl_group for the icon
                    -- title: set to anything or empty string to hide
                    cmdline = { pattern = "^:", icon = "", lang = "vim" },
                    search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                    search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
                    -- filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                    lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                    help = { pattern = "^:%s*he?l?p?%s+", icon = "" }, -- 󰋖
                    input = { view = "cmdline_input", icon = " " }, -- Used by input()    󰥻   󰌌   󰌏 󰥻 󰧹 󰌓 
                    -- lua = false, -- to disable a format, set to `false`
                },
            },
            messages = {
                -- NOTE: If you enable messages, then the cmdline is enabled automatically.
                -- This is a current Neovim limitation.
                enabled = true,
            },
            notify = {
                -- Noice can be used as `vim.notify` so you can route any notification like other messages
                -- Notification messages have their level and other properties set.
                -- event is always "notify" and kind can be any log level as a string
                -- The default routes will forward notifications to nvim-notify
                -- Benefit of using Noice for this is the routing and consistent history view
                enabled = true,
                view = "notify",
            },
            views = {
                cmdline_popup = {
                    enter = false,
                    position = {
                        row = 7,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                },
                cmdline_popupmenu = {
                    relative = "editor",
                    position = {
                        row = 10,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 13,
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                    },
                },
            },
            popupmenu = {
                backend = "nui", -- or "cmp" depending on your setup
                kind_icons = {},
            },
            lsp = {
                progress = {
                    enabled = false,
                },
                signature = {
                    enabled = false,
                },
                hover = {
                    enabled = true,
                    silent = true,
                },
                -- defaults for hover and signature help
                documentation = {
                    view = "hover",
                    ---@type NoiceViewOptions
                    opts = {
                        lang = "markdown",
                        replace = true,
                        render = "plain",
                        format = { "{message}" },
                        win_options = { concealcursor = "n", conceallevel = 3 },
                    },
                },
            },
            -- lsp = {
            --     override = {
            --         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            --         ["vim.lsp.util.stylize_markdown"] = true,
            --         ["cmp.entry.get_documentation"] = true,
            --     },
            --     progress = {
            --         enabled = false,
            --     },
            --     hover = {
            --         enabled = true,
            --         silent = true,
            --     },
            --     signature = {
            --         enabled = false,
            --         auto_open = {
            --             enabled = true,
            --             trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            --             luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            --             throttle = 300, -- Debounce lsp signature help request by 50ms
            --         },
            --         opts = {}, -- merged with defaults from documentation
            --     },
            -- },
            routes = {
                {
                    -- Remove noise from LSP
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "No information available" },
                        },
                    },
                    opts = { skip = true },
                },
                {
                    -- some short messages belongs to mini
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "line %d of %d --" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                            { find = "fewer lines" },
                        },
                    },
                    view = "mini",
                },
            },
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
        },
        -- stylua: ignore
        -- Normal key mapping, not restricted to any position
        keys = {
            { "<leader>sn",  "",                                                            desc = "+noice" },
            { "<leader>snl", function() require("noice").cmd("last") end,                   desc = "Noice Last Message" },
            { "<leader>snd", function() require("noice").cmd("dismiss") end,                desc = "Dismiss All" },
            { "<leader>snt", function() require("noice").cmd("pick") end,                   desc = "Noice Picker (Telescope/FzfLua)" },
            {
                "<S-Enter>",
                function()
                    require("noice").redirect(vim.fn.getcmdline(), {view = "popup"})
                end,
                mode = "c",
                desc = "Redirect Cmdline"
            },
        },
        config = function(_, opts)
            -- HACK: noice shows messages from before it was enabled,
            -- but this is not ideal when Lazy is installing plugins,
            -- so clear the messages in this case.
            if vim.o.filetype == "lazy" then
                vim.cmd([[messages clear]])
            end

            require("noice").setup(opts)
        end,
    },
}
