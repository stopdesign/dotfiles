-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
    pattern = "*",
    command = "tabdo wincmd =",
})

-- Fix toggleterm: start insert on focus
autocmd("BufEnter", {
    pattern = "term:/*",
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert!")
            vim.fn.timer_start(3, function()
                vim.cmd("startinsert!")
            end)
        end
    end,
})

-- Fix bufferline separator color and other highlights
local fixBufferLineSeparator = function()
    vim.api.nvim_set_hl(0, "BufferLineOffsetSeparator", vim.api.nvim_get_hl_by_name("NvimTreeWinSeparator", true))
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = fixBufferLineSeparator })
fixBufferLineSeparator()

vim.lsp.set_log_level("WARN")

--------------------
-- FIX JSON with jsonrepair
-- https://github.com/RealAlexandreAI/json-repair
--
local function process_with_jq()
    local mode = vim.api.nvim_get_mode().mode
    local buffer_content = ""

    local start_row, start_col, end_row, end_col

    if mode:find("[vV]") then
        -- Leave visual mode (to get start/end positions)
        local key = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(key, "n", true)

        vim.schedule(function()
            -- local selection_start = vim.api.nvim_buf_get_mark(0, "<")
            -- local selection_end = vim.api.nvim_buf_get_mark(0, ">")
            _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
            _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))

            local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

            -- Adjust for the column range in the first and last lines
            if #lines > 0 then
                lines[1] = string.sub(lines[1], start_col)
                lines[#lines] = string.sub(lines[#lines], 1, end_col)
            end

            buffer_content = table.concat(lines, "\n")
        end)
    else
        -- Normal mode: use the entire buffer content
        buffer_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    end

    -- This have to be after the previous schedule to know buffer_content
    vim.schedule(function()
        local pipeline = "jsonrepair -f /dev/stdin | jq"
        local command = { "sh", "-c", pipeline }

        local result = vim.system(command, { stdin = buffer_content, text = true }):wait()

        if result.code == 0 then
            local output = result.stdout or ""

            local new_lines = vim.split(output, "\n")
            if mode:find("[vV]") then
                -- Replace the selected lines
                vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, new_lines)
            else
                -- Replace the entire buffer content
                vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
            end
        else
            vim.notify(result.stderr, vim.log.levels.ERROR)
        end
    end)
end

vim.keymap.set({ "n", "v" }, "<leader>jl", function()
    -- vim.cmd("normal! gv")
    -- vim.api.nvim_input("\27")
    local mode = vim.fn.visualmode()

    local key = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(key, "n", true)

    vim.schedule(function()
        local selection_start = vim.api.nvim_buf_get_mark(0, "<")
        local selection_end = vim.api.nvim_buf_get_mark(0, ">")

        vim.info({ mode = mode, start = selection_start, finish = selection_end })
    end)
    -- vim.api.nvim_exec("normal! <Esc>", false)
    -- local key = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    -- vim.info(key)
    -- vim.api.nvim_feedkeys(key, "n", true)
    -- vim.info(vim.fn.getpos("'<"))
end, { silent = true, noremap = true, desc = "Get Cur Pos" })

vim.keymap.set({ "n", "v" }, "<leader>jj", function()
    process_with_jq()
end, { silent = true, noremap = true, desc = "Repair JSON" })

-- show diagnostics under cursor
vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = function()
        -- Avoid opening a diagnostic float if a floating window is already visible
        local floating_win_exists = false
        for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).relative ~= "" then
                floating_win_exists = true
                break
            end
        end

        if floating_win_exists then
            return
        end

        -- Open diagnostic float
        local success, err = pcall(function()
            vim.diagnostic.open_float(nil, {
                scope = "line",
                focusable = false,
                close_events = {
                    "CursorMoved",
                    "CursorMovedI",
                    "BufHidden",
                    "InsertCharPre",
                    "WinLeave",
                },
            })
        end)
        if not success then
            vim.notify("Failed to open diagnostic float: " .. err, vim.log.levels.ERROR)
        end
    end,
})
--
--

local d_v_t = function()
    local current = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = not current })
    print("Virtual Text: " .. (current and "Disabled" or "Enabled"))
end
vim.api.nvim_create_user_command("ToggleVirtualText", d_v_t, {})
vim.keymap.set({ "n" }, "<leader>uv", function()
    d_v_t()
end, { silent = true, noremap = true, desc = "Toggle diagnostics virtual text" })
--
--
--
local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
    pattern = "NvimTreeSetup",
    callback = function()
        local events = require("nvim-tree.api").events
        vim.info(events)
        events.subscribe(events.Event.NodeRenamed, function(data)
            vim.info(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
                data = data
                Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
        end)
    end,
})
