-- trailing space is required
vim.g.js_test_runner = 'pnpm jest '
vim.g.js_format_runner = 'pnpm prettier '
vim.g.js_lint_runner = 'pnpm eslint '

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
  },
  {
    type = "pwa-chrome",
    request = "attach",
    name = "Attach to Chrome",
    urlFilter = "http://localhost:3000/*",
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
    port = 9222,
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  },
  {
    type = "pwa-chrome",
    request = "launch",
    name = "Launch Chrome",
    url = "http://localhost:3000",
    webRoot = "${workspaceFolder}",
    runtimeArgs = { "--remote-debugging-port=9222" },
    sourceMaps = true,
    port = 9222,
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  }
};
dap.configurations.typescriptreact = dap.configurations.typescript;
