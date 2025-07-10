require("config.lazy")
require("config.lsp_config")
require("config.cmp_settings")
require("config.which_key_config")
require("leap").set_default_mappings()
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
	-- Enable or disable logging
	logging = false,
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = { require("formatter.filetypes.lua").stylua },
		python = { require("formatter.filetypes.python").black },
		javascript = { require("formatter.filetypes.javascript").prettier },
		html = { require("formatter.filetypes.html").prettier },
		css = { require("formatter.filetypes.css").prettier },

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
			-- Remove trailing whitespace without 'sed'
			-- require("formatter.filetypes.any").substitute_trailing_whitespace,
		},
	},
})
