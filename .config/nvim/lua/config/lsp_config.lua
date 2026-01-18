local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure language servers
local servers = {
	"lua_ls",
	"basedpyright",
	"cssls",
	"jsonls",
	"html",
	"rust_analyzer",
	"eslint",
}

for _, server in ipairs(servers) do
	vim.lsp.config(server, {
		capabilities = capabilities,
	})
	vim.lsp.enable(server)
end

-- Suppress irrelevant LSP notifications
local original_notify = vim.notify
vim.notify = function(msg, ...)
	if
		type(msg) == "string"
		and (msg:match("no client") or msg:match("hover capability") or msg:match("No information"))
	then
		return
	end
	original_notify(msg, ...)
end

-- LSP keybindings (registered on LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "Lsp: " .. desc })
		end

		local tele = require("telescope.builtin")

		-- Navigation
		map("gd", tele.lsp_definitions, "Goto Definition")
		map("<leader>gr", tele.lsp_references, "Goto References")
		map("gi", tele.lsp_implementations, "Goto Impl")
		map("<leader>ft", tele.lsp_type_definitions, "Goto Type")

		-- Symbols
		map("<leader>fs", tele.lsp_document_symbols, "Doc Symbols")
		map("<leader>fS", tele.lsp_dynamic_workspace_symbols, "Dynamic Symbols")

		-- Code actions and refactoring
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map("<leader>wf", vim.lsp.buf.format, "Format")

		-- Help and diagnostics
		map("K", vim.lsp.buf.hover, "Hover")
		map("<leader>k", vim.lsp.buf.signature_help, "Signature Help")
		map("<leader>E", vim.diagnostic.open_float, "Show Diagnostic")

		-- Visual mode code actions
		vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Lsp: code_action" })
	end,
})
vim.api.nvim_create_autocmd("CursorHold", {
	group = vim.api.nvim_create_augroup("LspHover", { clear = true }),
	callback = function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			if client.server_capabilities.hoverProvider then
				vim.lsp.buf.hover()
				break
			end
		end
	end,
})
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	opts.focusable = false
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
