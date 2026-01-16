local tele_built = require("telescope.builtin")

-- ===== ESCAPE SEQUENCES =====
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- ===== EDITING SHORTCUTS =====
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking selection" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Jump down half-page, center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Jump up half-page, center cursor" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result, center cursor" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result, center cursor" })

-- ===== NAVIGATION: BUFFERS =====
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader><leader>", ":buffer #<CR>", { desc = "Last used buffer" })
vim.keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Close buffer" })

-- ===== TELESCOPE: FIND =====
vim.keymap.set("n", "<leader>ff", tele_built.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", tele_built.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", tele_built.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", tele_built.help_tags, { desc = "Find Help Tags" })
vim.keymap.set("n", "<leader>fbf", tele_built.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Buffer" })

-- ===== TELESCOPE: UTILITIES =====
vim.keymap.set("n", "<leader>fc", tele_built.command_history, { desc = "Command History" })
vim.keymap.set("n", "<leader>t", tele_built.builtin, { desc = "Telescope Builtin" })
vim.keymap.set("n", "<leader>gs", tele_built.git_status, { desc = "Git Status" })

-- ===== DIAGNOSTICS =====
vim.keymap.set("n", "<leader>e", tele_built.diagnostics, { desc = "Diagnostics (Telescope)" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

-- ===== FILE EXPLORER =====
vim.keymap.set("n", "<leader>e", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "File Explorer (mini.files)" })

-- ===== GIT =====
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- ===== SAVE/FORMAT =====
vim.keymap.set("n", "<leader>ss", "<cmd>write<cr>", { desc = "Write File" })

-- ===== INFO POPUPS =====
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show Hover Info" })
vim.keymap.set("n", "<C-k>", function()
	require("lsp_signature").toggle_float_win()
end, { desc = "Toggle Signature Help" })
vim.keymap.set("n", "<Leader>k", vim.lsp.buf.signature_help, { desc = "Signature Help" })
