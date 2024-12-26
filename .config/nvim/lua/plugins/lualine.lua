return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local lualine = require("lualine")

        -- stylua: ignore
        local colors = {
            fg      = '#ffffff',
            bg      = '#e0e0e0',

            base3   = '#002b36',
            base2   = '#073642',
            base1   = '#586e75',
            base0   = '#657b83',
            base00  = '#738486',
            base01  = '#93a1a1',
            base02  = '#eee8d5',
            base03  = '#fdf6e3',

            yellow  = '#e59900',
            orange  = '#f07000',
            red     = '#dd0022',
            magenta = '#d33682',
            violet  = '#6c71c4',
            blue    = '#268bd2',
            cyan    = '#0ab185',
            green   = '#259900',
            gray    = '#666660',
        }

        local mode_color = {
            n = colors.base00,
            i = colors.green,
            v = colors.blue,
            [""] = colors.blue,
            V = colors.blue,
            c = colors.orange,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.red,
            t = colors.base3,
        }

        local gui_font = "None"
        local theme = {
            normal = {
                a = { bg = colors.bg, gui = gui_font },
                b = { bg = colors.bg, gui = gui_font },
                c = { bg = colors.bg, gui = gui_font },
                x = { bg = colors.bg, gui = gui_font },
                y = { bg = colors.bg, gui = gui_font },
                z = { bg = colors.bg, gui = gui_font },
            },
            insert = {
                a = { bg = colors.bg, gui = gui_font },
                b = { bg = colors.bg, gui = gui_font },
                c = { bg = colors.bg, gui = gui_font },
                x = { bg = colors.bg, gui = gui_font },
                y = { bg = colors.bg, gui = gui_font },
                z = { bg = colors.bg, gui = gui_font },
            },
            visual = {
                a = { bg = colors.bg, gui = gui_font },
                b = { bg = colors.bg, gui = gui_font },
                c = { bg = colors.bg, gui = gui_font },
                x = { bg = colors.bg, gui = gui_font },
                y = { bg = colors.bg, gui = gui_font },
                z = { bg = colors.bg, gui = gui_font },
            },
            replace = {
                a = { bg = colors.bg, gui = gui_font },
                b = { bg = colors.bg, gui = gui_font },
                c = { bg = colors.bg, gui = gui_font },
                x = { bg = colors.bg, gui = gui_font },
                y = { bg = colors.bg, gui = gui_font },
                z = { bg = colors.bg, gui = gui_font },
            },
            command = {
                a = { bg = colors.bg, gui = gui_font },
                b = { bg = colors.bg, gui = gui_font },
                c = { bg = colors.bg, gui = gui_font },
                x = { bg = colors.bg, gui = gui_font },
                y = { bg = colors.bg, gui = gui_font },
                z = { bg = colors.bg, gui = gui_font },
            },
            inactive = {
                a = { bg = colors.bg, gui = gui_font },
                b = { bg = colors.bg, gui = gui_font },
                c = { bg = colors.bg, gui = gui_font },
                x = { bg = colors.bg, gui = gui_font },
                y = { bg = colors.bg, gui = gui_font },
                z = { bg = colors.bg, gui = gui_font },
            },
        }

        local conditions = {
            hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end,
        }

        local function toggle_theme()
            if vim.o.background == "dark" then
                vim.o.background = "light"
            else
                vim.o.background = "dark"
            end
        end

        local function mason_updates()
            local registry = require("mason-registry")
            registry.refresh()
            local installed_packages = registry.get_installed_package_names()
            local upgrades_available = false
            local packages_outdated = 0
            local function myCallback(success, _)
                if success then
                    upgrades_available = true
                    packages_outdated = packages_outdated + 1
                end
            end

            for _, pkg in pairs(installed_packages) do
                local p = registry.get_package(pkg)
                if p then
                    p:check_new_version(myCallback)
                end
            end

            if upgrades_available then
                return packages_outdated
            else
                return 0
            end
        end

        local function show_macro_recording()
            local recording_register = vim.fn.reg_recording()
            if recording_register == "" then
                return ""
            else
                return "● rec @" .. recording_register
            end
        end

        local theme_bg = {
            function()
                return vim.o.background == "dark" and " Dark " or " Light"
            end,
            cond = nil,
            color = { fg = colors.gray },
            on_click = function()
                toggle_theme()
            end,
        }

        local mode = {
            "mode",
            padding = 2,
            separator = { left = "", right = "" },
            color = function()
                return { bg = mode_color[vim.fn.mode()], fg = colors.fg, gui = gui_font }
            end,
        }
        local filename = {
            "filename",
            color = { fg = colors.base3, bg = colors.bg, gui = gui_font },
        }
        local branch = {
            "branch",
            icon = "",
            color = { fg = colors.violet, bg = colors.bg, gui = gui_font },
            on_click = function()
                vim.cmd("Neogit")
            end,
        }
        local diagnostics = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " " }, -- 
            diagnostics_color = {
                color_error = { fg = colors.red, bg = colors.bg, gui = gui_font },
                color_warn = { fg = colors.yellow, bg = colors.bg, gui = gui_font },
                color_info = { fg = colors.cyan, bg = colors.bg, gui = gui_font },
            },
            color = { bg = colors.bg, gui = gui_font },
        }
        local macro_recording = {
            show_macro_recording,
            color = { bg = colors.red, fg = "#eeeeee" },
        }
        -- local copilot = {
        --   "copilot",
        --   symbols = {
        --     status = {
        --       hl = {
        --         enabled = colors.green,
        --         sleep = colors.yellow,
        --         disabled = colors.bg,
        --         warning = colors.orange,
        --         unknown = colors.red,
        --       },
        --     },
        --   },
        --   show_colors = true,
        --   color = { bg = "None", gui = "bold" },
        -- }
        local diff = {
            "diff",
            symbols = { added = "󰐕", modified = "~", removed = "󰍴" },
            diff_color = {
                added = { fg = colors.green, bg = colors.bg },
                modified = { fg = colors.orange, bg = colors.bg },
                removed = { fg = colors.red, bg = colors.bg },
            },
            cond = conditions.hide_in_width,
        }
        local fileformat = {
            "fileformat",
            fmt = string.upper,
            color = { fg = colors.green, bg = colors.bg, gui = gui_font },
        }
        local lazy = {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = colors.violet, bg = colors.bg },
            on_click = function()
                vim.ui.select({ "Yes", "No" }, { prompt = "Update plugins?" }, function(choice)
                    if choice == "Yes" then
                        vim.cmd("Lazy sync")
                    else
                        vim.notify("Update cancelled", vim.log.levels.INFO, { title = "Lazy" })
                    end
                end)
            end,
        }

        local function lsp_client()
            local clients = LazyVim.lsp.get_clients({ bufnr = 0 })
            if next(clients) == nil then
                return ""
            end

            local client_names = {}

            for _, client in ipairs(clients) do
                if client and client.name ~= "" then
                    table.insert(client_names, 1, client.name)
                end
            end

            table.sort(client_names)
            return table.concat(client_names, ", ")
        end

        local lsp_info = {
            function()
                return lsp_client() .. ""
            end,
            color = { fg = colors.green, bg = colors.bg, gui = gui_font },
        }

        local mason = {
            mason_updates() .. "",
            color = { fg = colors.violet, bg = colors.bg },
            cond = function()
                return mason_updates() > 0
            end,
            icon = "",
            on_click = function()
                vim.cmd("Mason")
            end,
        }
        local buffers = {
            function()
                local bufs = vim.api.nvim_list_bufs()
                local bufNumb = 0
                local function buffer_is_valid(buf_id, buf_name)
                    return 1 == vim.fn.buflisted(buf_id) and buf_name ~= ""
                end
                for idx = 1, #bufs do
                    local buf_id = bufs[idx]
                    local buf_name = vim.api.nvim_buf_get_name(buf_id)
                    if buffer_is_valid(buf_id, buf_name) then
                        bufNumb = bufNumb + 1
                    end
                end

                return " " .. bufNumb
            end,
            color = { fg = colors.blue, bg = colors.bg },
            on_click = function()
                vim.cmd("BufferList")
            end,
        }
        local filetype = {
            "filetype",
            color = { fg = colors.darkblue, bg = colors.bg },
        }
        local progress = {
            "progress",
            color = { fg = colors.magenta, bg = colors.bg },
        }
        local location = {
            "location",
            left_padding = 2,
            color = function()
                return { bg = mode_color[vim.fn.mode()], fg = colors.fg }
            end,
        }
        local sep = {
            "%=",
            section_separators = { left = "", right = "" },
        }
        local showcmd = {
            function()
                return "%=   " .. require("noice").api.status.command.get()
            end,
            cond = require("noice").api.status.command.has,
            color = { fg = colors.violet },
        }

        lualine.setup({
            options = {
                theme = theme,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                always_divide_middle = true,
                ignore_focus = { "NvimTree" },
            },
            sections = {
                lualine_a = { mode },
                lualine_b = { branch, filename, diff, diagnostics, macro_recording },
                lualine_c = { showcmd },
                --
                lualine_x = {},
                lualine_y = { theme_bg, lsp_info, buffers, filetype, progress },
                lualine_z = { location },
            },
            inactive_sections = {
                lualine_a = { "filename" },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { "location" },
            },
            tabline = {},
            extensions = {},
        })

        vim.api.nvim_create_autocmd("RecordingEnter", {
            callback = function()
                lualine.refresh()
            end,
        })

        vim.api.nvim_create_autocmd("RecordingLeave", {
            callback = function()
                local timer = vim.uv.new_timer()
                if not timer then
                    return
                end
                timer:start(
                    50,
                    0,
                    vim.schedule_wrap(function()
                        lualine.refresh()
                        timer:close()
                    end)
                )
            end,
        })
    end,
}
