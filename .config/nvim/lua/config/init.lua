require("config.lazy")
require("config.lsp_config")
require("config.cmp_settings")
require("config.which_key_config")
require("config.illuminate")
require("copilot-lsp").setup({ nes = { move_count_threshold = 3 } })
require("copilot").setup({
	suggestion = { enabled = true },
	panel = { enabled = true },
})
require("nvim-treesitter").setup({
	indent = {
		enable = true,
	},
	install_dir = vim.fn.stdpath("data") .. "/site",
})
require("nvim-treesitter").install({
	"rust",
	"javascript",
	"zig",
	"typescript",
	"python",
	"html",
	"jsx",
	"tsx",
})
require("leap").opts.preview = function(ch0, ch1, ch2)
	return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
end
require("leap").opts.equivalence_classes = {
	" \t\r\n",
	"([{",
	")]}",
	"'\"`",
}
require("toggleterm").setup({
	direction = "float",
	float_opts = {
		border = "single",
	},
	open_mapping = [[<C-\>]],
	start_in_insert = true,
})

require("leap.user").set_repeat_keys("<enter>", "<backspace>")
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Could be "●", "■", "▎", etc
		spacing = 2, -- space between text and diagnostic
	},
	signs = true, -- show signs in the gutter
	underline = true, -- underline problematic code
	update_in_insert = false, -- false = don't show while typing
	severity_sort = true, -- sort by severity
})

require("lsp_signature").setup({
	bind = true,
	handler_opts = {
		border = "rounded",
	},
	hint_enable = true,
	floating_window = true,
})

-- Code formatting with conform.nvim
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
	},
})

-- Auto-session setup
require("auto-session").setup({
	suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
})
require("mini.files").setup({
	options = {
		use_as_default_explorer = true,
		permanent_delete = true,
	},
	windows = {
		preview = true,
		width_preview = 100,
		width_focus = 30,
		width_nofocus = 15,
	},
})
require("mini.indentscope").setup()
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		require("auto-session").save_session()
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- Lualine status bar
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
	},
})

-- Auto-indent detection
require("guess-indent").setup({})
