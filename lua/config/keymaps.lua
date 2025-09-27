-- Move 1 line up or down in normal and visual modes
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('v', '<A-k>', ':m \'<-2<CR>gv=gv', { silent = true })
vim.keymap.set('v', '<A-j>', ':m \'>+1<CR>gv=gv', { silent = true })

-- Quickfix list navigation
vim.keymap.set('n', '<C-j>', ':cn<CR>', { silent = true })
vim.keymap.set('n', '<C-k>', ':cp<CR>', { silent = true })

-- Remap #
-- Normal mode: use "h register for highlight
vim.keymap.set('n', '#', function()
  local word = vim.fn.expand('<cword>')
  vim.fn.setreg('h', word) -- save in h register
  vim.fn.setreg('/', word) -- set as search
  vim.opt.hlsearch = true
end, { noremap = true, silent = true })

-- Visual mode: use "h register for highlight
vim.keymap.set('x', '#', function()
  -- yank into "h register (not default)
  vim.cmd('normal! "hy')
  local text = vim.fn.getreg('h')
  vim.fn.setreg('/', text) -- set as search
  vim.opt.hlsearch = true
  vim.cmd('normal! `<')    -- jump back to start of selection
end, { noremap = true, silent = true })

-- DELETE always into "d register
vim.keymap.set({'n','v'}, 'D', '"dD', { noremap = true })
vim.keymap.set({'n','v'}, 'x', '"dx', { noremap = true })
vim.keymap.set({'n','v'}, 'X', '"dX', { noremap = true })
vim.keymap.set({'n','v'}, 'c', '"dc', { noremap = true })
vim.keymap.set({'n','v'}, 'C', '"dC', { noremap = true })
