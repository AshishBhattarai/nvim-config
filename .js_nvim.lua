vim.g.js_package_manager = 'pnpm'

vim.keymap.set('n', '<A-F>', ':RunPrettier<CR>', { silent = true })
vim.keymap.set('n', '<leader>tf', ':RunJest<CR>', { silent = true })
vim.keymap.set('n', '<leader>tt', ':RunJestSpec<CR>', { silent = true })
vim.keymap.set('n', '<leader>te', ':RunESLint<CR>', { silent = true })
vim.keymap.set('n', '<leader>tE', ':RunESLintFix<CR>', { silent = true })

local dap = require("dap");
dap.configurations.typescript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file (ts-node)",
    program = "${workspaceFolder}/src/index.ts",
    cwd = "${workspaceFolder}",
    runtimeExecutable = "ts-node",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**" },
  }
}
dap.configurations.typescriptreact = {
  {
    type = "pwa-chrome",
    request = "attach",
    name = "Attach to Chrome",
    url = "http://localhost:3000",
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
    port = 9222,
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  }
}
