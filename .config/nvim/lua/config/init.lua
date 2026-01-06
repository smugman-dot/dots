require("config.lazy")
require("config.lsp_config")
require("config.cmp_settings")
require("config.which_key_config")
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

require("leap").opts.preview = function(ch0, ch1, ch2)
	return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
end
require("leap").opts.equivalence_classes = {
	" \t\r\n",
	"([{",
	")]}",
	"'\"`",
}
require("leap.user").set_repeat_keys("<enter>", "<backspace>")
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
require("lsp_signature").setup({
	bind = true,
	handler_opts = {
		border = "rounded",
	},
	hint_enable = true,
	floating_window = true,
})
require("formatter").setup({
	logging = true,
	filetype = {
		lua = { require("formatter.filetypes.lua").stylua },
		python = { require("formatter.filetypes.python").black },
		javascript = { require("formatter.filetypes.javascript").prettier },
		html = { require("formatter.filetypes.html").prettier },
		css = { require("formatter.filetypes.css").prettier },
		rust = { require("formatter.filetypes.rust").rustfmt },
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
require("toggleterm").setup({})
require("auto-session").setup({})
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
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		require("auto-session").save_session()
	end,
})
