local map = vim.keymap.set

return {
    {
        "akinsho/toggleterm.nvim",

        config = function()
            local Terminal = require("toggleterm.terminal").Terminal

            local lazygit = Terminal:new({
                cmd = "lazygit",
                dir = "git_dir",
                direction = "float",
                start_in_insert = true,
                float_opts = {
                    border = "double",
                },
                on_open = function(term)
                    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-k>", "<Nop>", { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-j>", "<Nop>", { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-l>", "<Nop>", { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                end,
            })

            function _G._lazygit_toggle()
                lazygit:toggle()
            end

            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
                start_in_insert = true,
                shade_terminals = false,
                shading_ratio = 0,
                direction = "float",
                persist_size = false,
                persist_mode = false,
                float_opts = {
                    border = "curved",
                    winblend = 0,
                    width = function()
                        return math.ceil(vim.o.columns * 0.7)
                    end,
                    height = function()
                        return math.ceil(vim.o.lines * 0.68)
                    end,
                },
                on_open = function(term)
                    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-l>", "<Nop>", { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                end,
            })

            -- Keybindings
            map("n", "<leader>gy", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = false })

            -- stylua: ignore start 
            map({ "n", "t" }, "<A-t>", "<cmd>1ToggleTerm direction=float<CR>", { desc = "terminal toggle floating", noremap = true, silent = true })
            map({ "n", "t" }, "<A-v>", "<cmd>2ToggleTerm direction=vertical<CR>", { desc = "terminal toggle vertical", noremap = true, silent = true })
            map({ "n", "t" }, "<A-h>", "<cmd>2ToggleTerm direction=horizontal<CR>", { desc = "terminal toggle horizontal", noremap = true, silent = true })
            -- stylua: ignore end

            map("n", "<leader>ii", function()
                local current_file = vim.fn.expand("%:p")

                local toggleterm = require("toggleterm.terminal")

                if current_file == "" then
                    print("No file in the current buffer.")
                    return
                end

                -- Check if the current file is a Python file
                if not current_file:match("%.py$") then
                    print("The current file is not a Python file.")
                    return
                end

                -- Save the current file before running
                vim.cmd("write")

                local terminal = toggleterm.get(2, true) -- include_hidden

                if not terminal then
                    terminal = toggleterm.Terminal:new({ id = 2, direction = "vertical" }):toggle()
                end

                if not terminal:is_open() then
                    terminal:toggle() -- Open the terminal if not visible
                end

                if not terminal:is_focused() then
                    terminal:focus()
                end

                if terminal then
                    terminal:send("python " .. current_file, false) -- Send the command to the terminal
                end
            end, { desc = "run python %current_file%", noremap = true, silent = true })

            map("n", "<leader>iu", function()
                -- Create or get the terminal instance
                -- local term = Terminal:new({ id = 1, direction = "horizontal" })

                -- Open the terminal
                -- Terminal:open()
                -- local command = string.format(":TermExec cmd='python %s'<CR>", current_file)
                if not Terminal:is_open() then
                    vim.cmd(":ToggleTerm")
                end

                -- Send the "Up" arrow key to recall the previous command
                vim.schedule(function()
                    if vim.bo.buftype == "terminal" then
                        vim.fn.timer_start(50, function()
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, false, true), "n", false)
                            vim.cmd("startinsert") -- Ensure terminal mode is active
                        end)
                    end
                end)
            end, { desc = "run last command", noremap = true, silent = true })
        end,
    },
}
