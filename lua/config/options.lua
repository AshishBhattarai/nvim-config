local home_dir = os.getenv("HOME")

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
vim.cmd([[autocmd ModeChanged [nvi]:[nvi] if &modifiable && &buftype ==# '' | silent write | endif]])
