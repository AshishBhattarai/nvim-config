-- JS tool commands
------------------------------------------------------------------------ 
function runPrettier()
    local filename = vim.fn.expand('%')
    local command = 'npx prettier "' .. filename .. '" --write'
    vim.cmd("w")
    vim.fn.system(command)
    -- Reopen the current file after running Prettier
    vim.cmd("e")
end

function runESLintFix()
    local filename = vim.fn.expand('%')
    local command = 'npx eslint "' .. filename .. '" --fix'
    vim.cmd("w")
    vim.fn.system(command)
    -- Reopen the current file
    vim.cmd("e")
end

local js_terminal_buffer = -1

local function runESLint()
  local fname = vim.fn.expand('%')
  local command = 'npx eslint ' .. fname
  -- If terminal buffer exists, delete it
  if js_terminal_buffer ~= -1 and vim.fn.bufexists(js_terminal_buffer) == 1 then
    vim.api.nvim_command(js_terminal_buffer.. 'bdelete')
  end 
  -- Open a new split terminal buffer and execute the Jest command
  vim.cmd('split | terminal ' .. command)
  js_terminal_buffer = vim.fn.bufnr('%')
  vim.cmd('wincmd p')
end

local function runJest(spec_name)
  local fname = vim.fn.expand('%:p')
  local test_name = spec_name and ' -t \'' .. spec_name .. '\'' or ''
  local command = 'npx jest ' .. fname .. test_name
  -- If terminal buffer exists, delete it
  if js_terminal_buffer ~= -1 and vim.fn.bufexists(js_terminal_buffer) == 1 then
    vim.api.nvim_command(js_terminal_buffer.. 'bdelete')
  end 
  -- Open a new split terminal buffer and execute the Jest command
  vim.cmd('split | terminal ' .. command)
  js_terminal_buffer = vim.fn.bufnr('%')
  vim.cmd('wincmd p')
end

function getCurrentLineText()
  local current_line = vim.api.nvim_get_current_line()
  local pattern = '%s*["\']([^"\']+)["\']'
  local captured_text = current_line:match(pattern)
  return captured_text
end

function runJestSpec() 
  local spec_name = getCurrentLineText();  
  return runJest(spec_name);
end
function runJestFile()
  return runJest(nil);
end

vim.api.nvim_create_user_command('RunPrettier', runPrettier, {})
vim.api.nvim_create_user_command('RunJest', runJestFile, {})
vim.api.nvim_create_user_command('RunJestSpec', runJestSpec, {})
vim.api.nvim_create_user_command('RunESLint', runESLint, {})
vim.api.nvim_create_user_command('RunESLintFix', runESLintFix, {})
------------------------------------------------------------------------ 
