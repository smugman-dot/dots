local cmp = require("cmp")
local copilot = require("copilot.suggestion")

-- Helper: Accept Copilot suggestion if visible
local function accept_copilot()
	if copilot.is_visible() then
		copilot.accept()
		return true
	end
	return false
end

-- Smart tab for CMP & Copilot
local function smart_tab(fallback)
	if accept_copilot() then
		return
	elseif cmp.visible() then
		cmp.select_next_item()
	else
		fallback()
	end
end

local function smart_s_tab(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	else
		fallback()
	end
end

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({

		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		["<Tab>"] = cmp.mapping(smart_tab, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(smart_s_tab, { "i", "s" }),

		["<C-l>"] = cmp.mapping(function(fallback)
			if accept_copilot() then
				return
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

	sources = cmp.config.sources({
		{ name = "copilot" },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
})
