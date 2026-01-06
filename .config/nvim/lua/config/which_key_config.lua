local tele_built = require("telescope.builtin")

vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>ff", tele_built.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", tele_built.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<leader>fb", tele_built.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", tele_built.help_tags, { desc = "Find Help" })
vim.keymap.set("n", "<leader>fc", tele_built.command_history, { desc = "COMMAND HISTORY" })
vim.keymap.set("n", "<leader>e", tele_built.diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>gs", tele_built.git_status, { desc = "Git Status" })
vim.keymap.set("n", "<leader>t", tele_built.builtin, { desc = "Telescope" })
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazy Git" })
vim.keymap.set("n", "<leader>ss", "<cmd>write<cr>", { desc = "Write File" })
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazy Git" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
-- Go to definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })

-- Peek definition (like VSCode peek)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

-- Go to references
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })

-- Go to implementation
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })

-- Show type / signature help
vim.keymap.set("n", "<leader>ds", vim.lsp.buf.document_symbol, { desc = "Document Symbols" })
vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, { desc = "Workspace Symbols" })

-- Quick code actions (fix, refactor, import)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("x", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" }) -- for visual selection

vim.keymap.set("n", "<leader>fbf", tele_built.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Buffer" })

-- Navigate diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostics" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics List" })

vim.keymap.set("n", "<leader>f", function()
	require("telescope.builtin").live_grep()
end, { desc = "Search in all files" })

vim.keymap.set("n", "<leader>e", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "Explorer (mini.files)" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover info" })
vim.keymap.set({ "n" }, "<C-k>", function()
	require("lsp_signature").toggle_float_win()
end, { silent = true, noremap = true, desc = "toggle signature" })

vim.keymap.set({ "n" }, "<Leader>k", function()
	vim.lsp.buf.signature_help()
end, { silent = true, noremap = true, desc = "toggle signature" })

local wk = require("which-key")
wk.add({
	{
		{ "<leader>wF", "<cmd>FormatWrite<cr>", desc = "Formatter Format" },
	},
})
