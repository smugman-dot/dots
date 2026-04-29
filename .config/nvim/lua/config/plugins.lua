return {
	-- Theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
	},
	{ "rose-pine/neovim",         name = "rose-pine" },
	-- LSP
	{ "neovim/nvim-lspconfig" },
	{ "VonHeikemen/lsp-zero.nvim" },
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
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
	{
		"nickjvandyke/opencode.nvim",
		version = "*", -- Latest stable release
		dependencies = {
			{
				-- `snacks.nvim` integration is recommended, but optional
				---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
				"folke/snacks.nvim",
				optional = true,
				opts = {
					input = {}, -- Enhances `ask()`
					picker = { -- Enhances `select()`
						actions = {
							opencode_send = function(...)
								return require("opencode")
									.snacks_picker_send(...)
							end,
						},
						win = {
							input = {
								keys = {
									["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
								},
							},
						},
					},
				},
			},
		},
		config = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- Your configuration, if any; goto definition on the type or field for details
			}

			vim.o.autoread = true -- Required for `opts.events.reload`

			-- Recommended/example keymaps
			vim.keymap.set({ "n", "x" }, "<C-a>",
				function() require("opencode").ask("@this: ", { submit = true }) end,
				{ desc = "Ask opencode…" })
			vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
				{ desc = "Execute opencode action…" })
			vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,
				{ desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
				{ desc = "Add range to opencode", expr = true })
			vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
				{ desc = "Add line to opencode", expr = true })

			vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
				{ desc = "Scroll opencode up" })
			vim.keymap.set("n", "<S-C-d>",
				function() require("opencode").command("session.half.page.down") end,
				{ desc = "Scroll opencode down" })

			-- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
			vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
			vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
		end,
	},
	-- Treesitter
	{ "nvim-treesitter/nvim-treesitter",            build = ":TSUpdate" },
	{
		'milanglacier/minuet-ai.nvim',
	},

	-- Telescope (fuzzy finder)
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Keybinding help
	{ "folke/which-key.nvim" },

	-- Motion
	{ url = "https://codeberg.org/andyg/leap.nvim", dependencies = { "tpope/vim-repeat" } },

	-- Terminal
	{ "akinsho/toggleterm.nvim",                    version = "*",                        config = true },

	-- File explorer
	{ "nvim-mini/mini.files" },

	-- Formatting
	{ "stevearc/conform.nvim" },

	-- Highlighting and visual features
	{ "YaQia/vim-illuminate" },
	{ "brenoprata10/nvim-highlight-colors" },
	{ "nvim-mini/mini.indentscope" },

	-- UI enhancements
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{ "ray-x/lsp_signature.nvim" },

	-- Auto-pairing
	{
		"windwp/nvim-autopairs",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"kawre/neotab.nvim",
		event = "InsertEnter",
		opts = {
			tabkey = "",
		},
	},
	{ "wakatime/vim-wakatime",   lazy = false },

	-- Session management
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		},
	},

	-- Indent detection
	{
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	},

	-- Dev tools
	{
		"folke/lazydev.nvim",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter",
				branch = "main",
				config = function()
					vim.api.nvim_create_autocmd("FileType", {
						pattern = { "llm", "markdown" },
						callback = function()
							vim.treesitter.start(0, "markdown")
						end,
					})
				end,
			},
			"nvim-mini/mini.icons",
		}, -- if you use standalone mini plugins
		ft = { "markdown", "llm" },

		config = function()
			require("render-markdown").setup({
				restart_highlighter = true,
				heading = {
					enabled = true,
					sign = false,
					position = "overlay", -- inline | overlay
					icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
					signs = { "󰫎 " },
					width = "block",
					left_margin = 0,
					left_pad = 0,
					right_pad = 0,
					min_width = 0,
					border = false,
					border_virtual = false,
					border_prefix = false,
					above = "▄",
					below = "▀",
					backgrounds = {},
					foregrounds = {
						"RenderMarkdownH1",
						"RenderMarkdownH2",
						"RenderMarkdownH3",
						"RenderMarkdownH4",
						"RenderMarkdownH5",
						"RenderMarkdownH6",
					},
				},
				dash = {
					enabled = true,
					icon = "─",
					width = 0.5,
					left_margin = 0.5,
					highlight = "RenderMarkdownDash",
				},
				code = { style = "normal" },
			})
		end,
	},
	-- {
	-- 	"MeanderingProgrammer/render-markdown.nvim",
	-- 	-- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
	-- 	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	-- 	---@module 'render-markdown'
	-- 	---@type render.md.UserConfig
	-- 	opts = {},
	-- },

	-- Alternative themes (commented out, using catppuccin instead)
	-- {
	-- 	"gbprod/nord.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("nord").setup({})
	-- 		vim.cmd.colorscheme("nord")
	-- 	end,
	-- },
	-- {
	-- 	"Mofiqul/dracula.nvim",
	-- 	lazy = false,
	-- },
}
