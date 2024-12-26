local function focus_first_normal_file_window()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_ft = vim.bo[buf].filetype
        local buf_bt = vim.bo[buf].buftype

        -- Check if it's a normal file buffer
        if buf_ft ~= "" and buf_bt == "" then
            vim.api.nvim_set_current_win(win)
            return
        end
    end
end

local function close_nvim_tree()
    require("nvim-tree.view").close()
end

local function open_nvim_tree()
    -- Restore nvim-tree after a session is restored
    local nvim_tree_api = require("nvim-tree.api")
    nvim_tree_api.tree.open()
    nvim_tree_api.tree.change_root(vim.fn.getcwd())
    nvim_tree_api.tree.reload()
end

local function pre_restore()
    local success, err = pcall(function()
        vim.cmd("norm! zR")
    end)
    if not success then
        vim.notify("Failed to restore folds: " .. err, vim.log.levels.ERROR)
        vim.cmd("set foldmethod=manual") -- Reset fold method as a fallback
    end
end

return {
    {
        "rmagatti/auto-session",
        lazy = false,
        version = "*",

        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config

        config = function()
            require("auto-session").setup({

                auto_session_suppress_dirs = { "~/", "/" }, -- Avoid saving sessions in these directories

                log_level = "error",
                pre_save_cmds = { close_nvim_tree },
                post_save_cmds = { open_nvim_tree },
                post_open_cmds = { open_nvim_tree },
                pre_restore_cmds = { pre_restore },
                post_restore_cmds = { open_nvim_tree, focus_first_normal_file_window },
                cwd_change_handling = {
                    restore_upcoming_session = true,
                    pre_cwd_changed_hook = close_nvim_tree,
                    post_cwd_changed_hook = open_nvim_tree,
                },
            })
        end,
    },
}
