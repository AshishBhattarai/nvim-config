vim.g.js_package_manager = 'pnpm'

vim.keymap.set('n', '<A-F>', ':RunPrettier<CR>', { silent = true })
vim.keymap.set('n', '<leader>tf', ':RunJest<CR>', { silent = true })
vim.keymap.set('n', '<leader>tt', ':RunJestSpec<CR>', { silent = true })
vim.keymap.set('n', '<leader>te', ':RunESLint<CR>', { silent = true })
vim.keymap.set('n', '<leader>tE', ':RunESLintFix<CR>', { silent = true })
