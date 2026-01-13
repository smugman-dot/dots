return {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "neovim/nvim-lspconfig" },
	{ "ggandor/leap.nvim", dependencies = { "tpope/vim-repeat" } },
	{ "hrsh7th/cmp-path" },
	{ "folke/which-key.nvim" },
	{ "zbirenbaum/copilot.lua" },
	{
		"stevearc/conform.nvim",
	},
	{
		"YaQia/vim-illuminate",
	},
	{
		"brenoprata10/nvim-highlight-colors",
	},
	{
		"Fildo7525/pretty_hover",
		event = "LspAttach",
		opts = {
			max_width = 80,
			max_heigh = 15,
			wrap = true,
			toggle = true,
			border = "none",
		},
	},
	{
		"gbprod/nord.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nord").setup({})
			vim.cmd.colorscheme("nord")
		end,
	},
	install = {
		colorscheme = { "nord" },
	},

	{
		"copilotlsp-nvim/copilot-lsp",
		init = function()
			vim.g.copilot_nes_debounce = 500
			vim.lsp.enable("copilot_ls")
			vim.keymap.set("n", "<tab>", function()
				local bufnr = vim.api.nvim_get_current_buf()
				local state = vim.b[bufnr].nes_state
				if state then
					local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
						or (
							require("copilot-lsp.nes").apply_pending_nes()
							and require("copilot-lsp.nes").walk_cursor_end_edit()
						)
					return nil
				else
					return "<C-i>"
				end
			end, { desc = "Accept Copilot NES suggestion", expr = true })
		end,
	},
	{ "nvim-mini/mini.files" },
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
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "rust_analyzer", "basedpyright", "ts_ls" },
		},
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
		"folke/lazydev.nvim",
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		-- Optional dependency
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			-- If you want to automatically add `(` after selecting a function or method
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = false,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "master", -- or "main" if the repo uses that
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
