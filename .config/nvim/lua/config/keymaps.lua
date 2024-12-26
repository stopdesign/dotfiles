-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local wk = require("which-key")
local neoscroll = require("neoscroll")

-- SCROLL
vim.keymap.set({ "n", "v", "x" }, "<C-e>", function()
    -- neoscroll.scroll(-0.5, { move_cursor = true, duration = 50 })
    neoscroll.ctrl_u({ duration = 150 })
end, { noremap = true, silent = true })

vim.keymap.set({ "n", "v", "x" }, "<C-d>", function()
    -- neoscroll.scroll(0.5, { move_cursor = true, duration = 50 })
    neoscroll.ctrl_d({ duration = 150 })
end, { noremap = true, silent = true })

vim.keymap.set({ "n", "v", "x" }, "<C-M-e>", function()
    neoscroll.scroll(-0.2, { move_cursor = false, duration = 50 })
end, { noremap = true, silent = true })

vim.keymap.set({ "n", "v", "x" }, "<C-M-d>", function()
    neoscroll.scroll(0.2, { move_cursor = false, duration = 50 })
end, { noremap = true, silent = true })

-- Удалить нахуй все кнопки от Trouble
vim.keymap.del({ "n" }, "<Space>xl")
vim.keymap.del({ "n" }, "<Space>xq")
vim.keymap.del({ "n" }, "<Space>xt")
vim.keymap.del({ "n" }, "<Space>xT")

-- Unregister a group by setting it to nil
wk.add({
    { "<leader>x", group = "", hidden = true },
})

vim.keymap.del({ "n" }, ">p")
vim.keymap.del({ "n" }, ">P")
vim.keymap.del({ "n" }, "<p")
vim.keymap.del({ "n" }, "<P")

vim.keymap.del({ "n" }, "<leader>K")

-- Лишние кнопки перемещения строки вверх-вниз
vim.keymap.del({ "n", "i", "v" }, "<M-j>")
vim.keymap.del({ "n", "i", "v" }, "<M-k>")

-- del can't remove default mapping
vim.keymap.set("n", "zs", "<nop>")
vim.keymap.set("n", "zl", "<nop>")
vim.keymap.set("n", "zL", "<nop>")

-- Remap MiniMove
map("x", "<m-j>", [[<Cmd>lua MiniMove.move_selection('left')<CR>]], { desc = "Move left" })
map("x", "<m-l>", [[<Cmd>lua MiniMove.move_selection('right')<CR>]], { desc = "Move right" })
map("x", "<m-k>", [[<Cmd>lua MiniMove.move_selection('down')<CR>]], { desc = "Move down" })
map("x", "<m-i>", [[<Cmd>lua MiniMove.move_selection('up')<CR>]], { desc = "Move up" })

map("n", "<m-j>", [[<Cmd>lua MiniMove.move_line('left')<CR>]], { desc = "Move line left" })
map("n", "<m-l>", [[<Cmd>lua MiniMove.move_line('right')<CR>]], { desc = "Move line right" })
map("n", "<m-k>", [[<Cmd>lua MiniMove.move_line('down')<CR>]], { desc = "Move line down" })
map("n", "<m-i>", [[<Cmd>lua MiniMove.move_line('up')<CR>]], { desc = "Move line up" })

-- Enter inserts a line from a normal mode
map({ "n" }, "<cr>", "o<esc>", { nowait = true, noremap = true })

map({ "n" }, "gd", function()
    vim.lsp.buf.definition()
end, { desc = "Toggle comment", remap = true, nowait = true })

-- Comment
map({ "n" }, "<C-_>", "gcc", { desc = "Toggle comment", remap = true })
map({ "v" }, "<C-_>", "gc", { desc = "Toggle comment", remap = true })
map({ "i" }, "<C-_>", "<Esc><Esc>gcc", { desc = "Toggle comment", remap = true })

map({ "n", "v" }, ";", ":", { nowait = true, noremap = true })

-- Remap movement keys
map({ "n", "v" }, "h", "<Nop>", { noremap = true, silent = true, desc = "Nothing" })
map({ "n", "v" }, "j", "<Left>", { noremap = true, silent = true, desc = "Move left" })
map({ "n", "v" }, "i", "<Up>", { noremap = true, silent = true, desc = "Move up" })
map({ "n", "v" }, "k", "<Down>", { noremap = true, silent = true, desc = "Move down" })
map({ "n", "v" }, "l", "<Right>", { noremap = true, silent = true, desc = "Move right" })

-- Insert Mode Arrow Key Replacements
map("i", "<C-j>", "<Left>", { noremap = true, silent = true, desc = "Move left in insert mode" })
-- map("i", "<C-i>", "<Up>", { noremap = true, silent = true, desc = "Move up in insert mode" })
map("i", "<C-k>", "<Down>", { noremap = true, silent = true, desc = "Move down in insert mode" })
map("i", "<C-l>", "<Right>", { noremap = true, silent = true, desc = "Move right in insert mode" })

map({ "n", "t" }, "<C-k>", "<cmd>wincmd j<CR>", { noremap = true, silent = true, desc = "Go to the window down" })
-- по каким-то неведомым причинам здесь нельзя перемапить mode="t", потому что тогда сломается <Tab> в терминале
-- https://unix.stackexchange.com/q
-- uestions/563469/conflict-ctrl-i-with-tab-in-normal-mode
map({ "n" }, "<C-i>", "<cmd>wincmd k<CR>", { noremap = true, silent = true, desc = "Go to the window up" })
map({ "n", "t" }, "<C-j>", "<cmd>wincmd h<CR>", { noremap = true, silent = true, desc = "Go to the window left" })

-- map("c", "<C-h>", "<C-p>", { noremap = true, silent = true })
map("n", "<S-j>", "<Cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true })
map("n", "<S-h>", "<Nop>", { noremap = true, silent = true })
-- map("n", "<C-h>", "<Nop>", { noremap = true, silent = true })
map({ "n", "t" }, "<C-h>", "<Cmd>NvimTreeFocus<CR>", { noremap = true, silent = true })

-- -- To navigate suggestions in Noice.nvim cmdline_popupmenu using Up and Down
-- -- stylua: ignore start
-- map("c", "<Up>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<Up>" end, { expr = true, noremap = true })
-- map("c", "<Down>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Down>" end, { expr = true, noremap = true })
-- -- stylua: ignore end

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode" })
-- map("t", "<C-h>", "<cmd>wincmd h<CR>", { noremap = true, silent = true })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
    vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })

-- vim.keymap.set({ "i" }, "<Esc>", function()
--   local cmp = require("cmp")
--   if cmp and cmp.visible() then
--     cmp.abort()
--     return
--   else
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
--   end
-- end, { noremap = true, silent = true, desc = "Close completion and hover" })

vim.keymap.set({ "v" }, "<leader>cg", function()
    local chatgpt = require("chatgpt")
    chatgpt.edit_with_instructions()
end, { noremap = true, silent = true, desc = "GPT this" })

-- SPIDER, w-e-b
vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
-- Insert mode
vim.keymap.set("i", "<C-f>", "<Esc>l<cmd>lua require('spider').motion('w')<CR>i")
vim.keymap.set("i", "<C-b>", "<Esc><cmd>lua require('spider').motion('b')<CR>i")

-- -- LUASNIP
-- local ls = require("luasnip")
--
-- -- stylua: ignore start
-- vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
-- vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
-- vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
--
-- vim.keymap.set({"i", "s"}, "<C-E>", function() if ls.choice_active() then ls.change_choice(1) end end, {silent = true})
-- -- stylua: ignore end
--
--
