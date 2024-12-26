local function multifile_plugin(api, bufnr)
    local opts = function(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- mark operation
    local mark_move_j = function()
        api.marks.toggle()
        vim.cmd("norm j")
    end
    local mark_move_k = function()
        api.marks.toggle()
        vim.cmd("norm k")
    end

    -- marked files operation
    local mark_trash = function()
        local marks = api.marks.list()
        if #marks == 0 then
            table.insert(marks, api.tree.get_node_under_cursor())
        end
        vim.ui.input({ prompt = string.format("Trash %s files? [y/n] ", #marks) }, function(input)
            if input == "y" then
                for _, node in ipairs(marks) do
                    api.fs.trash(node)
                end
                api.marks.clear()
                api.tree.reload()
            end
        end)
    end
    local mark_remove = function()
        local marks = api.marks.list()
        if #marks == 0 then
            table.insert(marks, api.tree.get_node_under_cursor())
        end
        vim.ui.input({ prompt = string.format("Remove/Delete %s files? [y/n] ", #marks) }, function(input)
            if input == "y" then
                for _, node in ipairs(marks) do
                    api.fs.remove(node)
                end
                api.marks.clear()
                api.tree.reload()
            end
        end)
    end

    local mark_copy = function()
        local marks = api.marks.list()
        if #marks == 0 then
            table.insert(marks, api.tree.get_node_under_cursor())
        end
        for _, node in pairs(marks) do
            api.fs.copy.node(node)
        end
        api.marks.clear()
        api.tree.reload()
    end
    local mark_cut = function()
        local marks = api.marks.list()
        if #marks == 0 then
            table.insert(marks, api.tree.get_node_under_cursor())
        end
        for _, node in pairs(marks) do
            api.fs.cut(node)
        end
        api.marks.clear()
        api.tree.reload()
    end

    vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
    vim.keymap.set("n", "J", mark_move_j, opts("Toggle Bookmark Down"))
    vim.keymap.set("n", "K", mark_move_k, opts("Toggle Bookmark Up"))

    vim.keymap.set("n", "dd", mark_cut, opts("Cut File(s)"))
    vim.keymap.set("n", "df", mark_trash, opts("Trash File(s)"))
    vim.keymap.set("n", "dF", mark_remove, opts("Remove File(s)"))
    vim.keymap.set("n", "yy", mark_copy, opts("Copy File(s)"))

    vim.keymap.set("n", "mv", api.marks.bulk.move, opts("Move Bookmarked"))
end

--
--

local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")

    local mappings = {
        -- BEGIN_DEFAULT_ON_ATTACH
        ["<C-]>"] = { api.tree.change_root_to_node, "CD" },
        ["<C-e>"] = { api.node.open.replace_tree_buffer, "Open: In Place" },
        ["<C-k>"] = { api.node.show_info_popup, "Info" },
        ["<C-r>"] = { api.fs.rename_sub, "Rename: Omit Filename" },
        ["<C-t>"] = { api.node.open.tab, "Open: New Tab" },
        ["<C-v>"] = { api.node.open.vertical, "Open: Vertical Split" },
        ["<C-x>"] = { api.node.open.horizontal, "Open: Horizontal Split" },
        ["<BS>"] = { api.node.navigate.parent_close, "Close Directory" },
        ["<CR>"] = { api.node.open.edit, "Open" },
        ["<Tab>"] = { api.node.open.preview, "Open Preview" },
        [">"] = { api.node.navigate.sibling.next, "Next Sibling" },
        ["<"] = { api.node.navigate.sibling.prev, "Previous Sibling" },
        ["."] = { api.node.run.cmd, "Run Command" },
        ["-"] = { api.tree.change_root_to_parent, "Up" },
        ["a"] = { api.fs.create, "Create" },
        ["bmv"] = { api.marks.bulk.move, "Move Bookmarked" },
        ["B"] = { api.tree.toggle_no_buffer_filter, "Toggle No Buffer" },
        ["c"] = { api.fs.copy.node, "Copy" },
        ["C"] = { api.tree.toggle_git_clean_filter, "Toggle Git Clean" },
        ["[c"] = { api.node.navigate.git.prev, "Prev Git" },
        ["]c"] = { api.node.navigate.git.next, "Next Git" },
        ["d"] = { api.fs.remove, "Delete" },
        ["D"] = { api.fs.trash, "Trash" },
        ["E"] = { api.tree.expand_all, "Expand All" },
        ["e"] = { api.fs.rename_basename, "Rename: Basename" },
        ["]e"] = { api.node.navigate.diagnostics.next, "Next Diagnostic" },
        ["[e"] = { api.node.navigate.diagnostics.prev, "Prev Diagnostic" },
        ["F"] = { api.live_filter.clear, "Clean Filter" },
        ["f"] = { api.live_filter.start, "Filter" },
        ["g?"] = { api.tree.toggle_help, "Help" },
        ["gy"] = { api.fs.copy.absolute_path, "Copy Absolute Path" },
        ["H"] = { api.tree.toggle_hidden_filter, "Toggle Dotfiles" },
        ["I"] = { api.tree.toggle_gitignore_filter, "Toggle Git Ignore" },
        ["J"] = { api.node.navigate.sibling.last, "Last Sibling" },
        ["K"] = { api.node.navigate.sibling.first, "First Sibling" },
        ["m"] = { api.marks.toggle, "Toggle Bookmark" },
        ["o"] = { api.node.open.edit, "Open" },
        ["O"] = { api.node.open.no_window_picker, "Open: No Window Picker" },
        ["p"] = { api.fs.paste, "Paste" },
        ["P"] = { api.node.navigate.parent, "Parent Directory" },
        ["r"] = { api.fs.rename, "Rename" },
        ["R"] = { api.tree.reload, "Refresh" },
        ["s"] = { api.node.run.system, "Run System" },
        ["S"] = { api.tree.search_node, "Search" },
        ["U"] = { api.tree.toggle_custom_filter, "Toggle Hidden" },
        ["W"] = { api.tree.collapse_all, "Collapse" },
        ["x"] = { api.fs.cut, "Cut" },
        ["y"] = { api.fs.copy.filename, "Copy Name" },
        ["Y"] = { api.fs.copy.relative_path, "Copy Relative Path" },
        ["<2-LeftMouse>"] = { api.node.open.edit, "Open" },
        ["<2-RightMouse>"] = { api.tree.change_root_to_node, "CD" },
        -- END_DEFAULT_ON_ATTACH

        -- Mappings migrated from view.mappings.list
        ["l"] = { api.node.open.edit, "Open" },
        ["h"] = { api.node.navigate.parent_close, "Close Directory" },
        ["v"] = { api.node.open.vertical, "Open: Vertical Split" },
    }

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Function to open directories but ignore files
    local function open_directory_only()
        local node = api.tree.get_node_under_cursor()

        if node.type == "directory" then
            api.node.open.edit(node) -- Open the directory
        end
    end

    -- close directory only
    local function close_directory_only()
        local node = api.tree.get_node_under_cursor()

        if node.type == "directory" then
            api.node.navigate.parent_close(node)
        end
    end

    local function expand_directory()
        local node = api.tree.get_node_under_cursor()
        api.tree.expand_all(node)
    end

    local function change_root_to_global_cwd()
        local api = require("nvim-tree.api")
        local global_cwd = vim.fn.getcwd(-1, -1)
        api.tree.change_root(global_cwd)
    end

    local function open_tab_silent(node)
        local api = require("nvim-tree.api")

        api.node.open.tab(node)
        vim.cmd.tabprev()
    end

    -- default mappings
    -- api.config.mappings.default_on_attach(bufnr)
    for keys, mapping in pairs(mappings) do
        vim.keymap.set("n", keys, mapping[1], opts(mapping[2]))
    end

    -- custom mappings
    vim.keymap.set("n", "<C-CR>", api.tree.change_root_to_node, opts("Set root"))
    vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
    vim.keymap.set("n", "<Right>", open_directory_only, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "<S-Right>", expand_directory, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "<S-Left>", api.tree.collapse_all, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "l", open_directory_only, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "<left>", api.node.navigate.parent_close, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "J", api.node.navigate.parent_close, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "j", close_directory_only, { buffer = bufnr, noremap = true, silent = true })
    -- vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
    -- vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
    vim.keymap.set("n", "<leader>e", api.tree.close, opts("Close"))
    vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
    -- vim.keymap.set("n", "<Space>", select_and_move_down)
    vim.keymap.set("n", "-", "<Nop>")
    vim.keymap.set("n", "<C-]>", "<Nop>")
    vim.keymap.set("n", "I", api.node.navigate.sibling.first, opts("First sibling"))
    vim.keymap.set("n", "K", api.node.navigate.sibling.last, opts("Last sibling"))

    local FloatPreview = require("float-preview")
    FloatPreview.attach_nvimtree(bufnr)

    multifile_plugin(api, bufnr)
end

local function label(path)
    path = path:gsub(os.getenv("HOME"), "~", 1)
    return path:gsub("([a-zA-Z])[a-z0-9]+", "%1") .. (path:match("[a-zA-Z]([a-z0-9]*)$") or "")
end

return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        { "s1n7ax/nvim-window-picker" },
        {
            "JMarkin/nvim-tree.lua-float-preview",
            lazy = true,
            -- default
            opts = {
                -- Whether the float preview is enabled by default. When set to false, it has to be "toggled" on.
                toggled_on = false,
                -- wrap nvimtree commands
                wrap_nvimtree_commands = true,
                -- lines for scroll
                scroll_lines = 20,
                -- window config
                window = {
                    style = "minimal",
                    relative = "win",
                    border = "rounded",
                    wrap = false,
                },

                mapping = {
                    -- scroll down float buffer
                    down = { "<C-d>" },
                    -- scroll up float buffer
                    up = { "<C-e>", "<C-u>" },
                    -- enable/disable float windows
                    toggle = { "<C-x>" },
                },
                -- hooks if return false preview doesn't shown
                hooks = {
                    pre_open = function(path)
                        -- if file > 5 MB or not text -> not preview
                        local size = require("float-preview.utils").get_size(path)
                        if type(size) ~= "number" then
                            return false
                        end
                        local is_text = require("float-preview.utils").is_text(path)
                        return size < 5 and is_text
                    end,
                    post_open = function(bufnr)
                        return true
                    end,
                },
            },
        },
    },
    config = function()
        vim.api.nvim_set_keymap("", "<leader>e", ":NvimTreeToggle<cr>", { silent = true, noremap = true })

        require("nvim-tree").setup({
            -- for "ahmedkhalf/project.nvim"
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = false, -- кажется, false не дает выходить за пределы root проекта
            },
            --
            hijack_cursor = true,
            sort = {
                sorter = "name",
            },
            view = {
                width = 35,
                adaptive_size = false,
            },
            git = {
                enable = true,
                ignore = false,
                timeout = 500,
            },
            actions = {
                open_file = {
                    window_picker = {
                        enable = true,
                        picker = function()
                            return require("window-picker").pick_window({ hint = "floating-big-letter" })
                        end,
                    },
                },
            },
            renderer = {
                root_folder_label = label,
                group_empty = label,
                -- group_empty = true,
                indent_markers = {
                    enable = true,
                    inline_arrows = true,
                },
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = false,
                    },
                },
            },
            filters = {
                dotfiles = false,
                custom = { "__pycache__", "%.pyc" },
            },
            on_attach = my_on_attach,
        })
    end,
}
