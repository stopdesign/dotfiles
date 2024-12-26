return {
    {
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        config = function()
            require("chatgpt").setup({
                api_key = "sk-***",
                openai_params = {
                    model = "gpt-4o",
                    frequency_penalty = 0,
                    presence_penalty = 0,
                    max_tokens = 4095,
                    temperature = 0.4,
                    top_p = 0.1,
                    n = 1,
                },
                chat = {
                    question_sign = "@", -- 🙂  
                    answer_sign = "#", -- 🤖  󱚠  󰚩  󱚝    󱋊󰭹󰭻󰛂󱋴  󰵰󰙃󰹽 󱁷 󱜽 󰍡 󱜾 󰍨
                    sessions_window = {
                        active_sign = "111",
                        inactive_sign = "222",
                        current_line_sign = ">",
                        win_options = {
                            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenu",
                            -- winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                        },
                    },
                },
            })
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim", -- optional
            "nvim-telescope/telescope.nvim",
        },
    },
}
