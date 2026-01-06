require("config")

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.tabstop = 4 -- how many spaces is a tab
vim.opt.shiftwidth = 4 -- how many spaces to indent
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smartindent = true -- auto-indent on new lines
vim.opt.scrolloff = 10
vim.opt.undofile = true
vim.opt.sidescrolloff = 5 -- horizontal padding when moving sideways
vim.opt.sidescroll = 1 -- smooth horizontal scroll
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.softtabstop = 4 -- Backspace and Tab key work as 4 spaces
vim.opt.autoindent = true -- Copy indent from the previous line

vim.api.nvim_create_autocmd("BufWritePost", {
	group = "FormatAutogroup",
	pattern = "*",
	command = "FormatWrite",
})

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

guifont = "JetBrainsMono Nerd Font:h12"
-- require("catppuccin").setup({
-- 	flavour = "mocha", -- latte, frappe, macchiato, mocha
-- 	background = { -- :h background
-- 		light = "latte",
-- 		dark = "mocha",
-- 	},
-- 	transparent_background = true,
-- })
local dracula = require("dracula")
dracula.setup({ transparent_bg = true })
vim.cmd("colorscheme dracula")
-- Highlight current line
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#313244" }) -- Surface0, subtle background
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f5c2e7", bold = true }) -- Line number of current line

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "dracula-nvim",
	},
})
require('guess-indent').setup {}
