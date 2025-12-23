require("config.lazy")
require("config.lsp_config")
require("config.cmp_settings")
require("config.which_key_config")
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"html",
		"css",
		"javascript",
		"tsx",
		"json",
		"lua",
	},
	highlight = {
		enable = true,
	},
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
-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("lsp_signature").setup({
	bind = true,
	handler_opts = {
		border = "rounded",
	},
	hint_enable = true,
	floating_window = true,
})
require("formatter").setup({
	logging = false,
	filetype = {
		lua = { require("formatter.filetypes.lua").stylua },
		python = { require("formatter.filetypes.python").black },
		javascript = { require("formatter.filetypes.javascript").prettier },
		html = { require("formatter.filetypes.html").prettier },
		css = { require("formatter.filetypes.css").prettier },
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
require("toggleterm").setup({})
require("auto-session").setup({})
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		require("auto-session").SaveSession()
	end,
})
require("neo-tree").setup({
	event_handlers = {

		{
			event = "file_open_requested",
			handler = function()
				-- auto close
				-- vim.cmd("Neotree close")
				-- OR
				require("neo-tree.command").execute({ action = "close" })
			end,
		},
	},
})
