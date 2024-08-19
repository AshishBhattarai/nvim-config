-- Move 1 line up or down in normal and visual modes
vim.keymap.set('n', '<A-j>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('n', '<A-k>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('v', '<A-k>', ':m \'<-2<CR>gv=gv', { silent = true })
vim.keymap.set('v', '<A-j>', ':m \'>+1<CR>gv=gv', { silent = true })

-- Quickfix list navigation
vim.keymap.set('n', '<C-j>', ':cn<CR>', { silent = true })
vim.keymap.set('n', '<C-k>', ':cp<CR>', { silent = true })

-- Remap # and *
vim.keymap.set('n', '#', '#``', { noremap = true });
vim.keymap.set('n', '*', '%', { noremap = true });

-- Coq keymaps
vim.keymap.set('i', '<TAB>', 'v:lua.user_keymaps.tab_completion()', { silent = true, expr = true, noremap = false })
vim.keymap.set('i', '<Esc>', [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]], { expr = true, silent = true })

local function checkBackSpace()
  local col = vim.fn.col('.') - 1
  return col <= 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

local function esc(cmd)
  return vim.api.nvim_replace_termcodes(cmd, true, true, true)
end

local function tabCompletion()
  if vim.fn.pumvisible() > 0 then
    local key = vim.fn.complete_info().selected == -1 and '<C-n><C-y>' or '<C-y>'
    return esc(key)
  elseif checkBackSpace() then
    return esc('<TAB>')
  else
    return esc('<C-x><C-u>')
  end
end

_G.user_keymaps = {
  tab_completion = tabCompletion
}
