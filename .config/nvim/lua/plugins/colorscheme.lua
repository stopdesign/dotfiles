return {
    {
        enabled = true,
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("catppuccin").setup({

                color_overrides = {
                    all = {
                        -- this 16 colors are changed to onedark
                    },
                    latte = {
                        rosewater = "#cc7983",
                        flamingo = "#bb5d60",
                        pink = "#d54597",
                        mauve = "#a65fd5",
                        red = "#b7242f",
                        maroon = "#db3e68",
                        peach = "#e46f2a",
                        yellow = "#bc8705",
                        green = "#1a8e32",
                        teal = "#00a390",
                        sky = "#089ec0",
                        sapphire = "#0ea0a0",
                        blue = "#017bca",
                        lavender = "#8584f7",
                        text = "#444444",
                        subtext1 = "#555555",
                        subtext0 = "#666666",
                        overlay2 = "#777777",
                        overlay1 = "#888888",
                        overlay0 = "#999999",
                        surface2 = "#aaaaaa",
                        surface1 = "#bbbbbb",
                        surface0 = "#cccccc",
                        base = "#ffffff",
                        mantle = "#eeeeee",
                        crust = "#dddddd",
                    },
                    frappe = {},
                    macchiato = {
                        rosewater = "#eb7a73",
                        flamingo = "#eb7a73",
                        red = "#eb7a73",
                        maroon = "#eb7a73",
                        pink = "#e396a4",
                        mauve = "#e396a4",
                        peach = "#e89a5e",
                        yellow = "#e8b267",
                        green = "#b9c675",
                        teal = "#99c792",
                        sky = "#99c792",
                        sapphire = "#99c792",
                        blue = "#8dbba3",
                        lavender = "#cbbfc3",
                        text = "#f1f4f2",
                        subtext1 = "#e5d5b1",
                        subtext0 = "#c5bda3",
                        overlay2 = "#b8a994",
                        overlay1 = "#a39284",
                        overlay0 = "#656565",
                        surface2 = "#5d5d5d",
                        surface1 = "#505050",
                        surface0 = "#393939",
                        base = "#2e3233",
                        mantle = "#242727",
                        crust = "#1f2223",
                    },
                    mocha = {
                        rosewater = "#ffc0b9",
                        flamingo = "#f5aba3",
                        pink = "#f592d6",
                        mauve = "#c0afff",
                        red = "#ea746c",
                        maroon = "#ff8595",
                        peach = "#fa9a6d",
                        yellow = "#ffe081",
                        green = "#99d783",
                        teal = "#47deb4",
                        sky = "#00d5ed",
                        sapphire = "#00dfce",
                        blue = "#00baee",
                        lavender = "#abbff3",
                        text = "#cccccc",
                        subtext1 = "#bbbbbb",
                        subtext0 = "#aaaaaa",
                        overlay2 = "#999999",
                        overlay1 = "#888888",
                        overlay0 = "#777777",
                        surface2 = "#666666",
                        surface1 = "#555555",
                        surface0 = "#444444",
                        base = "#202020",
                        mantle = "#222222",
                        crust = "#333333",
                    },
                },
                --

                flavour = "latte", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false, -- disables setting the background color.
                show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
                term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
                dim_inactive = {
                    enabled = true, -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15, -- percentage of the shade to apply to the inactive window
                },
                default_integrations = true,
                integrations = {
                    blink_cmp = true,
                    barbecue = {
                        dim_dirname = true, -- directory name is dimmed by default
                        bold_basename = true,
                        dim_context = false,
                        alt_background = false,
                    },
                    colorful_winsep = {
                        enabled = true,
                        color = "rosewater",
                    },
                    dashboard = true,
                    flash = true,
                    fzf = true,
                    grug_far = true,
                    headlines = true,
                    illuminate = true,
                    indent_blankline = { enabled = true },
                    leap = true,
                    markdown = true,
                    render_markdown = true,
                    mini = true,
                    fidget = true,
                    harpoon = true,
                    mason = true,
                    neotree = false,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    telescope = true,
                    lsp_trouble = true,
                    which_key = true,
                    neotest = true,
                    noice = true,
                    notify = true,
                    semantic_tokens = true,
                    snacks = true,
                    treesitter_context = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                            ok = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                            ok = { "underline" },
                        },
                        inlay_hints = {
                            background = true,
                        },
                    },
                    ufo = true,
                },
            })
        end,
        specs = {
            {
                "akinsho/bufferline.nvim",
                optional = true,
                opts = function(_, opts)
                    if (vim.g.colors_name or ""):find("catppuccin") then
                        opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
                    end
                end,
            },
        },
    },
    { "sainnhe/edge" },
    { "sainnhe/sonokai" },
    { "sainnhe/gruvbox-material" },
    { "disrupted/one.nvim" },
    { "NLKNguyen/papercolor-theme" },
    {
        "yorik1984/newpaper.nvim",
        priority = 1000,
        opts = {
            -- style = "light",
            contrast_float = false,
            contrast_telescope = false,
            italic_strings = false,
            italic_comments = false,
            italic_doc_comments = false,
            italic_functions = false,
            italic_variables = false,
            custom_highlights = {
                Normal = { bg = "#f5f2f1" },
                NormalNC = { bg = "#efeceb" },
                --
                SnacksIndent = { fg = "#e0d8d5", bg = "NONE" },
                -- Window separator and cursor highlights
                WinSeparator = { bg = "#dddddd", fg = "#dddddd" },
                CursorColumnHL = { fg = "#a0a0a0", bg = "NONE" },

                ActiveTerminal = { bg = "#f5f5f5", fg = "#000000" },
                InactiveTerminal = { bg = "#ebe9e5", fg = "#555555" },

                NvimTreeLineNr = { bg = "#f5f2f0" },
                NvimTreeNormal = { bg = "#f5f2f0", fg = "#444444" },
                NvimTreeSignColumn = { bg = "#f5f2f0" },
                NvimTreeSpecialFile = { fg = "#8700af", cterm = {} },

                -- Line number highlights
                LineNr = { bg = "NONE", fg = "#888888" },
                CursorLineNr = { bg = "#e6e6e6", fg = "#cc6666" },
                SignColumn = { bg = "NONE" },

                -- -- Inline virtual text diagnostics - remove background
                DiagnosticVirtualTextError = { bg = "NONE", fg = "#d75f66" },
                DiagnosticVirtualTextWarn = { bg = "NONE", fg = "#d37300" },
                DiagnosticVirtualTextInfo = { bg = "NONE", fg = "#005faf" },
                DiagnosticVirtualTextHint = { bg = "NONE", fg = "#0ea674" },
                DiagnosticVirtualTextOk = { bg = "NONE", fg = "#0ea628" },

                LualineSignature = { fg = "#555555", bg = "#e0e0e0" },
                LualineSignatureHint = { fg = "#dd4400", underline = true, bg = "#e0e0e0" },
                LspSignatureActiveParameter = { fg = "#dd4400", underline = true, bg = "NONE" },
            },
        },
    },
}
