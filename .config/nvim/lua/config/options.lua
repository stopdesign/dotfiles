-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

vim.g.startify_session_dir = "~/.config/nvim/sessions/"
vim.g.startify_fortune_use_unicode = 1

vim.g.virtcolumn_char = "▕" -- char to display the line  >>>>
vim.g.virtcolumn_priority = 10

vim.g.python_indent = {
    disable_parentheses_indenting = false,
    closed_paren_align_last_line = false, -- default: true
    searchpair_timeout = 50,
    continue = "shiftwidth() * 2",
    open_paren = "shiftwidth()", -- default: 'shiftwidth() * 2'
    nested_paren = "shiftwidth()",
}

vim.opt.pumblend = 0
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.conceallevel = 3
vim.opt.numberwidth = 6
vim.opt.relativenumber = false
vim.opt.colorcolumn = "100"

vim.opt.smoothscroll = false

vim.opt.mouse = "a"
vim.opt.mousemoveevent = true

vim.opt.wildignorecase = true
vim.opt.wildmode = "list:full" -- Command-line completion mod
vim.opt.wildoptions = "fuzzy" -- Enable fuzzy search in command-lin
vim.opt.winminwidth = 0 -- Minimum window width

-- -- :h fillchars
-- vim.opt.fillchars = {
--     --
--     horiz = "━",
--     horizup = "┻",
--     horizdown = "┳",
--     --
--     vert = "┃",
--     vertleft = "┫",
--     vertright = "┣",
--     verthoriz = "╋",
--     --
--     fold = " ",
--     eob = " ", -- suppress ~ at EndOfBuffer
--     diff = "╱", -- alternatives = ⣿ ░ ─
-- }

-- что сохранять в сессии
vim.o.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal"

-- ширина курсора в разных режимах
-- vim.o.guicursor = "n:block-nCursor,v:block-vCursor,i:ver25-iCursor,r:hor25-rCursor,c:ver25-cCursor"
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor25"

vim.opt.list = true -- Enable display of whitespace characters
vim.opt.listchars:append({
    trail = "·",
    tab = " ", -- Tab guide symbol ⇥ 
})

-- maintain undo history between sessions
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- fuzzy find
vim.opt.path:append("**")

-- lazy file name tab completion
vim.opt.wildmode = "list:longest,list:full"
vim.opt.wildmenu = true
vim.opt.wildignorecase = true

-- case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true

-- make backspace behave in a sane manner
vim.opt.backspace = "indent,eol,start"

-- searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"

vim.opt.shiftwidth = 4
-- use indents of 2

-- tabs are spaces
vim.opt.expandtab = true

-- an indentation every * columns
vim.opt.tabstop = 4

-- let backspace delete indent
vim.opt.softtabstop = 4

-- enable auto indentation
vim.opt.autoindent = true

-- show break symbol in the beginning of wrapped lines
vim.o.showbreak = " ↳  "

vim.o.updatetime = 200 -- time before float diagnostic shows

vim.diagnostic.config({
    update_in_insert = true,
    underline = true,
    virtual_text = false, -- Turn off inline diagnostics
    float = {
        show_header = false,
        source = true, -- true | if_many
        border = "none",
        focusable = false,
        severity_sort = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
        },
    },
})

vim.g.move_map_keys = 0
