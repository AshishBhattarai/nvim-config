local home_dir = os.getenv("HOME")

-- encoding
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.fileencodings = 'utf-8'

-- conceal level
vim.opt.conceallevel = 2

-- tab size
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- persistent undo
vim.opt.undofile = true
vim.opt.undodir = home_dir .. '/.local/share/nvim/undo'
vim.opt.dir = home_dir .. '/.local/share/nvim/swap'
-- Lost files on power outage
vim.opt.fsync = true

-- Copy from clipboard
vim.opt.clipboard = 'unnamedplus'

-- Fold
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Autowriteall and Autoread
vim.opt.autowriteall = true
vim.opt.autoread = true

-- Colorcolumn
vim.opt.colorcolumn = '120'
vim.cmd('highlight ColorColumn ctermbg=8 guibg=lightorange')

-- Relative line numbers
vim.opt.relativenumber = true

-- Split behavior
vim.opt.splitright = true

-- Automatically save when switching modes
-- vim.api.nvim_create_autocmd("ModeChanged", {
--   pattern = "[nvi]:[nvi]",
--   callback = function()
--     local modifiable = vim.bo.modifiable
--     local buftype = vim.bo.buftype
--     local file = vim.fn.expand('%')
--     local filereadable = vim.fn.filereadable(file) == 1
--
--     if modifiable and buftype == '' and filereadable then
--       vim.cmd("silent write")
--     end
--   end,
-- })

-- exrc - local vim config
vim.o.exrc = true
vim.o.secure = true
