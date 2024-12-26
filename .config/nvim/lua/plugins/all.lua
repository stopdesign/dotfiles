--
-- Подключение временных плагинов для опытов
--
--
-- 1
-- 2
-- 3
-- 4
-- 5
-- 6
-- 7
--
--
return {
    {
        "LazyVim/LazyVim",
        opts = {},
    },

    { "jokajak/keyseer.nvim", version = "*", config = true },

    { "gw31415/scrollUptoLastLine.vim" },

    { "uga-rosa/ccc.nvim", config = true },

    { "rktjmp/lush.nvim" },

    -- FIXME: интересно, но не работает нормально
    { "nvimtools/hydra.nvim", enabled = false },

    {
        "EL-MASTOR/bufferlist.nvim",
        lazy = true,
        keys = {
            {
                "hh",
                function(o)
                    vim.cmd("BufferList")
                end,
                desc = "Open bufferlist",
            },
        },
        dependencies = "nvim-tree/nvim-web-devicons",
        cmd = "BufferList",
        opts = {
            width = 60,
            keymap = {
                close_buf_prefix = "c",
                force_close_buf_prefix = "f",
                save_buf = "s",
                multi_close_buf = "m",
                multi_save_buf = "w",
                save_all_unsaved = "a",
                close_all_saved = "d0",
                toggle_path = "p",
                close_bufferlist = "<Esc>",
            },
            win_keymaps = {
                {
                    "<cr>",
                    function(opts)
                        local curpos = vim.fn.line(".")
                        vim.cmd("bwipeout | buffer " .. opts.buffers[curpos])
                    end,
                    { desc = "BufferList: my description" },
                },
            },
        },
    },

    {
        "stevearc/conform.nvim",
        opts = {
            default_format_opts = {
                timeout_ms = 3000,
                async = false, -- not recommended to change
                quiet = false, -- not recommended to change
                lsp_format = "fallback", -- not recommended to change
            },
            formatters_by_ft = {
                lua = { "stylua" },
                fish = { "fish_indent" },
                sh = { "shfmt" },
                python = { "ruff_organize_imports", "ruff_format", lsp_format = "fallback" },
                css = { "prettier" },
                graphql = { "prettier" },
                html = { "prettier", lsp_format = "fallback" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                json = { "prettier" },
                markdown = { "prettier" },
                rust = { "rustfmt", lsp_format = "fallback" },
                svelte = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                yaml = { "prettier" },
            },
            formatters = {
                stylua = {
                    prepend_args = function()
                        return { "--indent-width", "4" }
                    end,
                },
                prettier = {
                    prepend_args = function()
                        return { "--tab-width", "4" }
                    end,
                },
            },
        },
        enabled = true,
    },

    -- TODO: не пользуюсь
    {
        enabled = true,
        "stevearc/aerial.nvim",
        config = function()
            require("aerial").setup({
                layout = {
                    max_width = { 40, 0.2 },
                    width = 30,
                    min_width = 30,
                    default_direction = "left",
                    resize_to_content = false,
                },
            })
            vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
        end,
    },

    { "rebelot/heirline.nvim" },

    -- Мощная штука, работа с json через jq в специальном окне
    {
        "cenk1cenk2/jq.nvim",
        dependencies = {
            -- https://github.com/nvim-lua/plenary.nvim
            "nvim-lua/plenary.nvim",
            -- https://github.com/MunifTanjim/nui.nvim
            "MunifTanjim/nui.nvim",
            -- https://github.com/grapp-dev/nui-components.nvim
            "grapp-dev/nui-components.nvim",
        },
        config = function()
            require("jq").setup({
                border = "rounded",
            })
        end,
    },

    {
        "echasnovski/mini.indentscope",
        version = "*", -- wait till new 0.7.0 release to put it back on semver
        event = "LazyFile",
        opts = {
            -- symbol = "▏",
            symbol = "│",
            -- Draw options
            draw = {
                -- Delay (in ms) between event and start of drawing scope indicator
                delay = 100,

                -- Symbol priority. Increase to display on top of more symbols.
                priority = 1,
            },
            options = {
                border = "both",
                indent_at_cursor = false,
                try_as_border = true,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "Trouble",
                    "alpha",
                    "dashboard",
                    "fzf",
                    "help",
                    "lazy",
                    "mason",
                    "neo-tree",
                    "notify",
                    "snacks_dashboard",
                    "snacks_notif",
                    "snacks_terminal",
                    "snacks_win",
                    "toggleterm",
                    "trouble",
                    "nvtree",
                    "nofile",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "SnacksDashboardOpened",
                callback = function(data)
                    vim.b[data.buf].miniindentscope_disable = true
                end,
            })
        end,
    },

    {
        "folke/snacks.nvim",
        priority = 500,
        -- FIXME: пришлось поставить последнюю версию
        ---@type snacks.Config
        version = "v2.11.0",
        opts = {
            indent = {
                priority = 0,
                indent = {
                    priority = 0,
                    char = "│", -- ▏│▎
                },
                scope = { enabled = false },
                animate = {
                    enabled = vim.fn.has("nvim-0.10") == 1,
                    style = "out",
                    easing = "linear",
                    duration = {
                        step = 20, -- ms per step
                        total = 300, -- maximum duration
                    },
                },
            },
            terminal = {
                enabled = false,
            },
            input = {
                -- портит переименование в nvim-tree
                enabled = false,
            },
            dim = {
                enabled = false,
            },
            scratch = {
                -- your scratch configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
            win = {
                show = true,
                fixbuf = true,
                relative = "editor",
                position = "float",
                minimal = true,
                backdrop = 80,
                wo = {
                    number = false,
                    relativenumber = false,
                    signcolumn = "no",
                },
                bo = {},
                keys = {
                    q = {
                        "<esc>",
                        function(self)
                            vim.schedule(function()
                                self:close()
                            end)
                        end,
                        mode = "n",
                        desc = "close",
                    },
                },
            },
            styles = {
                notification_history = {
                    border = "rounded",
                    width = 0.8,
                    height = 0.4,
                    ft = "markdown",
                    keys = {
                        q = {
                            "<esc>",
                            function(self)
                                vim.schedule(function()
                                    self:close()
                                end)
                            end,
                            mode = "n",
                            desc = "close",
                        },
                    },
                },
            },
        },
        --stylua: ignore
        keys = {
            -- { "<leader>/",  false},
            { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
            { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
            { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
            { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
            { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
            { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
            { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
            { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
            { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
            { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
            { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
            { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
            { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
            { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
            { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` command

                    -- Create some toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.line_number():map("<leader>ul")
                    Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                    Snacks.toggle.treesitter():map("<leader>uT")
                    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                    Snacks.toggle.indent():map("<leader>ug")
                    Snacks.toggle.dim():map("<leader>uD")
                end,
            })
        end,
    },

    { "nvim-neo-tree/neo-tree.nvim", enabled = false },

    {
        "rcarriga/nvim-notify",
    },

    -- Норм тема. Меняет поведение кнопок w-e-b
    {
        "chrisgrieser/nvim-spider",
        lazy = true,
        opts = {
            subwordMovement = false,
        },
    },

    {
        "smjonas/inc-rename.nvim",
        enabled = true,
        config = function()
            require("inc_rename").setup({
                show_message = false,
                save_in_cmdline_history = false,
            })
            vim.keymap.set("n", "<leader>rn", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { expr = true })
        end,
    },

    -- Show match number and index for searching
    {
        "kevinhwang91/nvim-hlslens",
        enabled = true,
        branch = "main",
        keys = { "*", "#", "n", "N" },
        priority = 3000,
        config = function()
            require("hlslens").setup({
                calm_down = true,
                override_lens = function(render, posList, nearest, idx, relIdx)
                    local sfw = vim.v.searchforward == 1
                    local indicator, text, chunks
                    local absRelIdx = math.abs(relIdx)
                    if absRelIdx > 1 then
                        indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
                    elseif absRelIdx == 1 then
                        indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
                    else
                        indicator = ""
                    end

                    local lnum, col = unpack(posList[idx])
                    if nearest then
                        local cnt = #posList
                        if indicator ~= "" then
                            text = ("[%s %d/%d]"):format(indicator, idx, cnt)
                        else
                            text = ("[%d/%d]"):format(idx, cnt)
                        end
                        chunks = { { " " }, { text, "HlSearchLensNear" } }
                    else
                        text = ("[%s %d]"):format(indicator, idx)
                        chunks = { { " " }, { text, "HlSearchLens" } }
                    end
                    render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
                end,
            })
        end,
    },

    -- Plugin to manipulate character pairs quickly
    { "machakann/vim-sandwich", event = "VeryLazy", enabled = false },

    -- Python-related text object
    { "jeetsukumaran/vim-pythonsense", ft = { "python" }, enabled = false },

    -- Add indent object for vim (useful for languages like Python)
    { "michaeljsmith/vim-indent-object", event = "VeryLazy", enabled = false },

    -- Move lines and blocks
    {
        "echasnovski/mini.move",
        event = "VeryLazy",
        version = "*",
        config = function()
            require("mini.move").setup({
                mappings = {},
            })
        end,
    },

    -- парные скобки, включены только в Insert Mode
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        version = "*",
        config = function()
            require("mini.pairs").setup({
                modes = { insert = true, command = false, terminal = false },
                mappings = {
                    -- Prevents the action if the cursor is just before any character or next to a "\".
                    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][%s%)%]%}]" },
                    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][%s%)%]%}]" },
                    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][%s%)%]%}]" },
                    -- This is default (prevents the action if the cursor is just next to a "\").
                    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
                    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
                    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
                    -- Prevents the action if the cursor is just before or next to any character.
                    ['"'] = {
                        action = "closeopen",
                        pair = '""',
                        neigh_pattern = "[^%w][^%w]",
                        register = { cr = false },
                    },
                    ["'"] = {
                        action = "closeopen",
                        pair = "''",
                        neigh_pattern = "[^%w][^%w]",
                        register = { cr = false },
                    },
                    ["`"] = {
                        action = "closeopen",
                        pair = "``",
                        neigh_pattern = "[^%w][^%w]",
                        register = { cr = false },
                    },
                },
            })
        end,
    },

    -- TODO: работает, но иногда предлагает левые окна (mini?)
    {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        event = "VeryLazy",
        version = "2.*",
        config = function()
            require("window-picker").setup({
                show_prompt = false,
                hint = "floating-big-letter",
                -- when you go to window selection mode, status bar will show one of
                -- following letters on them so you can use that letter to select the window
                selection_chars = "FJDKSLA;CMRUEIWOQP",
                filter_rules = {
                    bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = { "NvimTree", "neo-tree", "notify", "snacks_notif", "toggleterm", "noice" },

                        -- if the file type is one of following, the window will be ignored
                        buftype = { "terminal", "quickfix" },
                    },
                },
                -- This section contains picker specific configurations
                picker_config = {
                    statusline_winbar_picker = {
                        -- You can change the display string in status bar.
                        -- It supports '%' printf style. Such as `return char .. ': %f'` to display
                        -- buffer file path. See :h 'stl' for details.
                        selection_display = function(char, windowid)
                            return "%=" .. char .. "%="
                        end,

                        -- whether you want to use winbar instead of the statusline
                        -- "always" means to always use winbar,
                        -- "never" means to never use winbar
                        -- "smart" means to use winbar if cmdheight=0 and statusline if cmdheight > 0
                        use_winbar = "never", -- "always" | "never" | "smart"
                    },

                    floating_big_letter = {
                        -- window picker plugin provides bunch of big letter fonts
                        -- fonts will be lazy loaded as they are being requested
                        -- additionally, user can pass in a table of fonts in to font
                        -- property to use instead

                        font = "ansi-shadow", -- ansi-shadow |
                    },
                },
            })
        end,
    },

    {
        "karb94/neoscroll.nvim",
        enabled = true,
        config = function()
            local neoscroll = require("neoscroll")
            neoscroll.setup({
                performance_mode = false,
                respect_scrolloff = true,
                mappings = {},
            })
            local keymap = {
                -- ["<C-y>"] = function()
                --     neoscroll.scroll(-0.1, { move_cursor = false, duration = 50 })
                -- end,
                -- ["<C-e>"] = function()
                --     neoscroll.scroll(0.1, { move_cursor = false, duration = 50 })
                -- end,
                ["zt"] = function()
                    neoscroll.zt({ half_win_duration = 100 })
                end,
                ["zz"] = function()
                    neoscroll.zz({ half_win_duration = 100 })
                end,
                ["zb"] = function()
                    neoscroll.zb({ half_win_duration = 100 })
                end,
            }
            local modes = { "n", "v", "x" }
            for key, func in pairs(keymap) do
                vim.keymap.set(modes, key, func)
            end
        end,
    },

    -- полоска cc (правая граница кода)
    {
        "xiyaowong/virtcolumn.nvim",
        config = function()
            vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "OptionSet" }, {
                callback = function()
                    -- Only for a normal editor buffer, not terminal or neotree or help...
                    if vim.bo.buftype ~= "" then
                        vim.opt_local.colorcolumn = "0"
                    end
                end,
            })
        end,
    },

    {
        "nvim-tree/nvim-web-devicons",
    },

    -- дашборд с коровой (но без коровы)
    {
        "mhinz/vim-startify",
    },
    -- -- дашборд мини
    -- { import = "lazyvim.plugins.extras.ui.mini-starter" },

    -- { "saadparwaiz1/cmp_luasnip" },

    {
        "L3MON4D3/LuaSnip",
        enabled = true,
        lazy = false,
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            require("luasnip").setup({})
        end,
    },

    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            -- Only one of these is needed, not both.
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua", -- optional
        },
        config = true,
    },

    -- --------------------------------
    -- FROM EXAMPLE

    -- change trouble config
    {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleToggle" },
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {
            use_diagnostic_signs = true, -- Use the signs already defined in LSP
        },
        enabled = false, -- FIXME: выключил из-за кнопки X
        keys = {},
    },

    {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },

    -- FIXME: не работает
    -- For selecting virtual envs
    {
        "linux-cultist/venv-selector.nvim",
        lazy = false,
        enabled = false,
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            require("venv-selector").setup()
        end,
        keys = {
            { "cv", "<cmd>VenvSelect<cr>" },
        },
    },

    -- add more treesitter parsers
    {
        "nvim-treesitter/nvim-treesitter",
        version = "v0.9.*",
        opts = {
            ensure_installed = {
                "bash",
                "html",
                "css",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "vim",
                "yaml",
                "toml",
                "htmldjango",
                "latex",
            },
            highlight = {
                enable = true,
                disable = { "help" }, -- list of language that will be disabled
                additional_vim_regex_highlighting = false,
            },
        },
    },

    -- FIXME: часто мешает
    {
        "windwp/nvim-ts-autotag",
        enabled = false,
        event = "LazyFile",
        opts = {},
    },

    -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
    { import = "lazyvim.plugins.extras.lang.json" },

    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "stylua",
                "shellcheck",
                "shfmt",
                "ruff",
                "lua-language-server",
                "html-lsp",
                "python-lsp-server",
            },
        },
    },
}
