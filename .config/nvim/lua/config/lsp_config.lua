-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities =
	vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		vim.keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		vim.keymap.set("n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		vim.keymap.set("n", "<leader>vca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	end,
})

local buffer_autoformat = function(bufnr)
	local group = "lsp_autoformat"
	vim.api.nvim_create_augroup(group, { clear = false })
	vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		group = group,
		desc = "LSP format on save",
		callback = function()
			-- note: do not enable async formatting
			vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
		end,
	})
end

local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		-- Super tab
		["<Tab>"] = cmp.mapping(function(fallback)
			local luasnip = require("luasnip")
			local col = vim.fn.col(".") - 1

			if cmp.visible() then
				cmp.select_next_item({ behavior = "select" })
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
				fallback()
			else
				cmp.complete()
			end
		end, { "i", "s" }),

		-- Super shift tab
		["<S-Tab>"] = cmp.mapping(function(fallback)
			local luasnip = require("luasnip")

			if cmp.visible() then
				cmp.select_prev_item({ behavior = "select" })
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local id = vim.tbl_get(event, "data", "client_id")
		local client = id and vim.lsp.get_client_by_id(id)
		if client == nil then
			return
		end
		require("lsp_signature").on_attach(signature_setup, event.buf)

		-- make sure there is at least one client with formatting capabilities
		if client.supports_method("textDocument/formatting") then
			buffer_autoformat(event.buf)
		end
	end,
})

vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.HINT] = "⚑",
			[vim.diagnostic.severity.INFO] = "»",
		},
	},
})
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
--
-- -- Configure language servers
-- local servers = {
-- 	"lua_ls",
-- 	"basedpyright",
-- 	"cssls",
-- 	"jsonls",
-- 	"html",
-- 	"rust_analyzer",
-- 	"eslint",
-- }
--
-- for _, server in ipairs(servers) do
-- 	vim.lsp.config(server, {
-- 		capabilities = capabilities,
-- 	})
-- 	vim.lsp.enable(server)
-- end
--
-- -- Suppress irrelevant LSP notifications
-- local original_notify = vim.notify
-- vim.notify = function(msg, ...)
-- 	if
-- 		type(msg) == "string"
-- 		and (msg:match("no client") or msg:match("hover capability") or msg:match("No information"))
-- 	then
-- 		return
-- 	end
-- 	original_notify(msg, ...)
-- end
--
-- -- LSP keybindings (registered on LspAttach)
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
-- 	callback = function(ev)
-- 		local map = function(keys, func, desc)
-- 			vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "Lsp: " .. desc })
-- 		end
--
-- 		local tele = require("telescope.builtin")
--
-- 		-- Navigation
-- 		map("gd", tele.lsp_definitions, "Goto Definition")
-- 		map("<leader>gr", tele.lsp_references, "Goto References")
-- 		map("gi", tele.lsp_implementations, "Goto Impl")
-- 		map("<leader>ft", tele.lsp_type_definitions, "Goto Type")
--
-- 		-- Symbols
-- 		map("<leader>fs", tele.lsp_document_symbols, "Doc Symbols")
-- 		map("<leader>fS", tele.lsp_dynamic_workspace_symbols, "Dynamic Symbols")
--
-- 		-- Code actions and refactoring
-- 		map("<leader>rn", vim.lsp.buf.rename, "Rename")
-- 		map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
-- 		map("<leader>wf", vim.lsp.buf.format, "Format")
--
-- 		-- Help and diagnostics
-- 		map("K", vim.lsp.buf.hover, "Hover")
-- 		map("<leader>k", vim.lsp.buf.signature_help, "Signature Help")
-- 		map("<leader>E", vim.diagnostic.open_float, "Show Diagnostic")
--
-- 		-- Visual mode code actions
-- 		vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Lsp: code_action" })
-- 	end,
-- })
-- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
-- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
-- 	opts = opts or {}
-- 	opts.border = opts.border or "rounded"
-- 	opts.focusable = false
-- 	return orig_util_open_floating_preview(contents, syntax, opts, ...)
-- end
