-- Move 1 line up or down in normal and visual modes
vim.keymap.set('n', '<A-j>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('n', '<A-k>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('v', '<A-k>', ':m \'<-2<CR>gv=gv', { silent = true })
vim.keymap.set('v', '<A-j>', ':m \'>+1<CR>gv=gv', { silent = true })

-- Quickfix list navigation
vim.keymap.set('n', '<C-j>', ':cn<CR>', { silent = true })
vim.keymap.set('n', '<C-k>', ':cp<CR>', { silent = true })

-- Lsp keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gu', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, 'ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<A-f>', vim.lsp.buf.format, opts)

    -- split jumps
    vim.keymap.set('n', '<leader>s', ':split | lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set('n', '<leader>v', ':vsplit | lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set('n', '<leader>.', [[<Cmd>let save_pos = getpos('.')<CR>:tabnew %<CR>:execute 'normal! ' . save_pos[1] . 'G' . save_pos[2] . '|'<CR>:lua vim.lsp.buf.definition()<CR>]], opts)
  end,
})

function checkBackSpace()
  local col = vim.fn.col('.') - 1
  return col <= 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

function esc(cmd)
  return vim.api.nvim_replace_termcodes(cmd, true, true, true)
end

function tabCompletion()
  if vim.fn.pumvisible() > 0 then
    local key = vim.fn.complete_info().selected == -1 and '<C-n><C-y>' or '<C-y>'
    return esc(key)
  elseif checkBackSpace() then
    return esc('<TAB>')
  else
    return esc('<C-x><C-u>')
  end
end

-- Coq keymaps
vim.keymap.set('i', '<TAB>', 'v:lua.user_keymaps.tab_completion()', { silent = true, expr = true, noremap = false })
vim.keymap.set('i', '<Esc>', [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]], { expr = true, silent = true })

_G.user_keymaps = {
  tab_completion = tabCompletion
}
