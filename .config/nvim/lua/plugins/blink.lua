return {
    {
        "saghen/blink.cmp",
        lazy = false, -- lazy loading handled internally
        -- optional: provides snippets for the snippet source
        -- dependencies = 'rafamadriz/friendly-snippets',

        -- use a release tag to download pre-built binaries
        -- version = false,
        version = "v0.8.*",
        -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        enabled = true,

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- see the "default configuration" section below for full documentation on how to define
            -- your own keymap.
            keymap = {
                preset = "enter",
                cmdline = {
                    preset = "super-tab",
                },
            },

            completion = {
                keyword = {
                    -- 'prefix' will fuzzy match on the text before the cursor
                    -- 'full' will fuzzy match on the text before *and* after the cursor
                    -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
                    range = "prefix",
                    -- Regex used to get the text when fuzzy matching
                    regex = "[-_]\\|\\k",
                    -- After matching with regex, any characters matching this regex at the prefix will be excluded
                    exclude_from_prefix_regex = "[\\-:,]",
                },

                menu = {
                    enabled = true,
                    min_width = 15,
                    max_height = 10,
                    border = "rounded",
                    winhighlight = "Normal:Normal,FloatBorder:Normal",

                    draw = {
                        treesitter = { "lsp" },
                        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
                    },
                },

                list = {
                    selection = "auto_insert",
                },

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                    treesitter_highlighting = true,
                    window = {
                        max_width = 88,
                        border = "rounded",
                        winhighlight = "Normal:Normal,FloatBorder:Normal",
                    },
                },

                ghost_text = {
                    enabled = false,
                },
            },

            -- experimental signature help support
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                    winhighlight = "NormalNC:NormalNC,FloatBorder:NormalNC",
                },
            },
            -- enabled = function()
            --   local node = vim.treesitter.get_node()
            --   local disabled = false
            --   disabled = disabled or (vim.tbl_contains({ "markdown" }, vim.bo.filetype))
            --   disabled = disabled or (vim.bo.buftype == "prompt")
            --   -- disabled = disabled or (node and string.find(node:type(), "comment"))
            --   return not disabled
            -- end,

            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`
            sources = {
                min_keyword_length = 1,
                default = { "lsp", "path", "buffer" },
            },
        },
        -- allows extending the providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { "sources.default" },
    },
}
