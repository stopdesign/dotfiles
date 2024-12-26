return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay = function(ctx)
                return ctx.plugin and 0 or 500
            end,
            preset = "modern",
            icons = {
                mappings = false,
                breadcrumb = "»",
                separator = "→",
                group = " ", --      󰐖 󰐗 
            },
            disable = {
                buftypes = {},
                filetypes = {},
            },
            filter = function(mapping)
                -- example to exclude mappings without a description
                -- return mapping.desc and mapping.desc ~= ""
                return true
            end,
        },
    },
}
