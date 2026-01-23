require("config")

-- Editor behavior
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Visual settings
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 5
vim.opt.sidescroll = 1
vim.o.updatetime = 2000
vim.opt.signcolumn = "yes"

-- Session/buffer options
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Filetype mapping: .js files treated as JSX
vim.filetype.add({
	extension = {
		js = "javascriptreact",
	},
})

-- Treesitter language registration: use tsx parser for JSX/HTML in .js files
vim.treesitter.language.register("tsx", "javascriptreact")

-- Ensure treesitter highlighting starts for these filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascriptreact", "typescriptreact", "javascript", "typescript" },
	callback = function()
		vim.treesitter.start()
	end,
})

-- Restore cursor position on file open
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

-- GUI font
guifont = "JetBrainsMono Nerd Font:h12"

-- Catppuccin theme setup
require("catppuccin").setup({
	flavour = "macchiato", -- Using Macchiato as the base
	color_overrides = {
		macchiato = {
			rosewater = "#f4dbd6",
			flamingo = "#f0c6c6",
			pink = "#f5bde6", -- Matching the blush
			mauve = "#c6a0f6",
			red = "#ed8796",
			maroon = "#ee99a0",
			peach = "#f5a97f",
			yellow = "#eed49f",
			green = "#a6da95",
			teal = "#49BDC7", -- OVERRIDDEN: Matching Nyarch main body
			sky = "#84D0D9", -- OVERRIDDEN: Matching Nyarch highlights
			sapphire = "#298E82", -- OVERRIDDEN: Matching Nyarch ears/ring
			blue = "#8aadf4",
			lavender = "#b7bdf8",
			text = "#cad3f5",
			subtext1 = "#b8c0e0",
			subtext0 = "#a5adcb",
			overlay2 = "#939ab7",
			overlay1 = "#8087a2",
			overlay0 = "#6e738d",
			surface2 = "#5b6078",
			surface1 = "#494d64",
			surface0 = "#363a4f",
			base = "#24273a",
			mantle = "#1e2030",
			crust = "#181926",
		},
	},
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		treesitter = true,
		notify = true,
		mini = true,
	},
	transparent_background = true,
})

vim.cmd.colorscheme("catppuccin")

-- Highlight current line number
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#313244" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f5c2e7", bold = true })
