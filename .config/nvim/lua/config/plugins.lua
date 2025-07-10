return {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "neovim/nvim-lspconfig" },
	{ "mhartington/formatter.nvim" },
	{ "ggandor/leap.nvim", dependencies = { "tpope/vim-repeat" } },
	{ "hrsh7th/cmp-path" },
	{ "folke/which-key.nvim" },
	{
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	},
	{ "ray-x/lsp_signature.nvim" },
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
