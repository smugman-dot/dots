return {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "neovim/nvim-lspconfig" },
	{ "mhartington/formatter.nvim" },
	{ "ggandor/leap.nvim", dependencies = { "tpope/vim-repeat" } },
	{ "hrsh7th/cmp-path" },
	{ "folke/which-key.nvim" },
	{ "zbirenbaum/copilot.lua" },
	{
		"copilotlsp-nvim/copilot-lsp",
		init = function()
			vim.g.copilot_nes_debounce = 500
			vim.lsp.enable("copilot_ls")
			vim.keymap.set("n", "<tab>", function()
				local bufnr = vim.api.nvim_get_current_buf()
				local state = vim.b[bufnr].nes_state
				if state then
					-- Try to jump to the start of the suggestion edit.
					-- If already at the start, then apply the pending suggestion and jump to the end of the edit.
					local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
						or (
							require("copilot-lsp.nes").apply_pending_nes()
							and require("copilot-lsp.nes").walk_cursor_end_edit()
						)
					return nil
				else
					-- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
					return "<C-i>"
				end
			end, { desc = "Accept Copilot NES suggestion", expr = true })
		end,
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
	},
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		},
	},
	{
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	},
	{ "ray-x/lsp_signature.nvim" },
	{ "zbirenbaum/copilot-cmp" },
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		-- or , branch = '0.1.x',
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"rafamadriz/friendly-snippets",
		},
	},
}
