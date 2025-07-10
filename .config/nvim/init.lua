require("config")

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.tabstop = 4       -- how many spaces is a tab
vim.opt.shiftwidth = 4     -- how many spaces to indent
vim.opt.expandtab = true   -- use spaces instead of tabs
vim.opt.smartindent = true -- auto-indent on new lines
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "FormatAutogroup",
  pattern = "*",
  command = "FormatWrite",
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local file = vim.api.nvim_buf_get_name(0)
    if file ~= "" and vim.fn.isdirectory(file) == 0 then
      vim.cmd("lcd %:p:h")
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

guifont = "JetBrainsMono Nerd Font:h12" 
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = true})
local cat = "catppuccin-mocha";
vim.cmd("colorscheme catppuccin-mocha")

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = cat,
    }
})
