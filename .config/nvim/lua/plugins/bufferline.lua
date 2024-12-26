local function get_window_with_buffer(bufnr)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
            return win -- Return the window showing the buffer
        end
    end
    return nil -- No window found
end

local function close_buffer(bufnr, force)
    local win = get_window_with_buffer(bufnr) -- Find the window showing the buffer
    local buffers = vim.fn.getbufinfo({ buflisted = 1 }) -- Get all listed buffers

    if #buffers == 1 then
        -- If this is the last buffer, open a new one
        if win and win ~= vim.api.nvim_get_current_win() then
            vim.api.nvim_set_current_win(win) -- Focus on the window
        end
        vim.cmd("enew") -- Create a new empty buffer
    elseif win then
        -- If there are multiple buffers, switch to the previous one
        local prev_bufnr = nil
        for i, buf in ipairs(buffers) do
            if buf.bufnr == bufnr then
                prev_bufnr = buffers[i - 1] and buffers[i - 1].bufnr or buffers[#buffers].bufnr
                break
            end
        end

        if prev_bufnr then
            vim.api.nvim_win_set_buf(win, prev_bufnr) -- Set the previous buffer in the window
        end
    end

    -- Finally, delete the buffer
    if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_delete(bufnr, { force = force })
    end
end

vim.api.nvim_create_user_command("CloseTheFuckingBuffer", function()
    local buf = vim.api.nvim_win_get_buf(0)
    close_buffer(buf, false)
end, {})

vim.keymap.set({ "n" }, "<leader>x", function()
    local buf = vim.api.nvim_win_get_buf(0)
    close_buffer(buf, false)
end, { silent = true, noremap = true, desc = "Close Buffer", nowait = true })

vim.keymap.set({ "n" }, "<leader>X", function()
    local buf = vim.api.nvim_win_get_buf(0)
    close_buffer(buf, true)
end, { silent = true, noremap = true, desc = "Force Close Buffer", nowait = true })

return {
    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        enabled = true,
        version = "*",
        config = function()
            require("bufferline").setup({
                highlights = {
                    buffer_selected = { bold = false, italic = false },
                },
                options = {

                    show_buffer_icons = false,
                    separator_style = "thick", -- "slant" | "slope" | "thick" | "thin" | { "any", "any" },
                    always_show_bufferline = true,
                    auto_toggle_bufferline = true,
                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = { "close" },
                    },
                    offsets = {
                        {
                            filetype = "aerial",
                            text_align = "left",
                            separator = true,
                            text = function()
                                return "Content"
                            end,
                            highlight = "ToolbarLine",
                        },
                        {
                            filetype = "toggleterm",
                            text_align = "left",
                            separator = true,
                            text = function()
                                return "Terminal"
                            end,
                            highlight = "ToolbarLine",
                        },
                        {
                            filetype = "NvimTree",
                            text_align = "left",
                            separator = true,
                            text = function()
                                return "Tree"
                                -- return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
                            end,
                            highlight = "ToolbarLine",
                        },
                    },

                    -- diagnostics = 'nvim_lsp',
                    -- diagnostics_update_in_insert = false,
                    -- numbers = 'buffer_id',

                    -- Исправление закрытия буфера по клику на крестик
                    close_command = close_buffer,

                    -- Исправление клика по табу в bufferline
                    left_mouse_command = function(bufnum)
                        local windows = vim.api.nvim_list_wins()
                        for _, win in ipairs(windows) do
                            -- Get the buffer associated with the window
                            local buf = vim.api.nvim_win_get_buf(win)
                            -- Check if the buffer is valid and is a normal file buffer
                            local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
                            if buftype == "" then
                                -- Switch to this window
                                vim.api.nvim_set_current_win(win)
                                vim.api.nvim_win_set_buf(win, bufnum)
                                return
                            end
                        end
                    end,
                },
            })
        end,
    },
}
