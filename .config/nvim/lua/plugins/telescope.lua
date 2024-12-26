return {
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>fw", "<cmd>Telescope live_grep case_mode=smart_case<CR>", { desc = "telescope live grep" } },
            { "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" } },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" } },
            { "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" } },
            { "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" } },
            { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" } },
            { "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" } },
            { "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" } },
            { "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "telescope find all files" } },
            { "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "telescope find projects" } },
        },
        -- change some options
        opts = {
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                    ".git/",
                    ".venv/",
                    ".mypy_cache/",
                    "__pycache__",
                },
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
                mappings = {
                    i = {
                        -- ["<C-h>"] = require("telescope.actions").move_selection_previous,
                        ["<C-h>"] = "which_key",
                        ["<ESC>"] = require("telescope.actions").close,
                    },
                    n = {
                        ["<C-h>"] = "which_key",
                        -- ["<C-h>"] = require("telescope.actions").move_selection_previous,
                    },
                },
                extensions = {
                    projects = {},
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    },
                },
                -- stylua: ignore
                pickers = {
                    find_files = {
                        -- needed to exclude some files & dirs from general search
                        -- when not included or specified in .gitignore
                        find_command = {
                            "rg",
                            "--files",
                            "--hidden",
                            -- "--glob",
                            -- "!**/.git/*",
                            "--glob", "!**/.git/*",
                            "--glob", "!**/.venv/*",
                            "--glob", "!**/.DS_Store/*",
                            "--glob", "!**/node_modules/*",
                            "--glob", "!**/.vscode/*",
                        },
                    },
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--hidden",
                    "--smart-case",
                    "--ignore-file",
                    ".gitignore",
                },
            },
        },
    },
}
