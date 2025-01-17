-- JS tool commands
------------------------------------------------------------------------
vim.g.js_package_manager = 'pnpm'
local function runPrettier()
  local filename = vim.fn.expand('%')
  local command = vim.g.js_package_manager .. ' prettier "' .. filename .. '" --write'
  vim.cmd("w")
  vim.fn.system(command)
  vim.cmd("e")
end

local function runESLintFix()
  local filename = vim.fn.expand('%')
  local command = vim.g.js_package_manager .. ' eslint "' .. filename .. '" --fix'
  vim.cmd("w")
  vim.fn.system(command)
  vim.cmd("e")
end

local js_terminal_buffer = nil

local function runESLint()
  local fname = vim.fn.expand('%')
  local command = vim.g.js_package_manager .. ' eslint ' .. fname
  -- If terminal buffer exists, delete it
  if js_terminal_buffer and vim.api.nvim_buf_is_valid(js_terminal_buffer) then
    vim.cmd(js_terminal_buffer .. 'bdelete!')
  end
  -- Open a new split terminal buffer and execute the Jest command
  vim.cmd('split | terminal ' .. command)
  js_terminal_buffer = vim.fn.bufnr('%')
  vim.cmd('wincmd p')
end

local function runJest(spec_name)
  local fname = vim.fn.expand('%:p')
  local test_name = spec_name and ' -t \'' .. spec_name .. '\'' or ''
  local command = vim.g.js_package_manager .. ' jest ' .. fname .. test_name
  -- If terminal buffer exists, delete it
  if js_terminal_buffer and vim.api.nvim_buf_is_valid(js_terminal_buffer) then
    vim.cmd(js_terminal_buffer .. 'bdelete!')
  end
  -- Open a new split terminal buffer and execute the Jest command
  vim.cmd('split | terminal ' .. command)
  js_terminal_buffer = vim.fn.bufnr('%')
  vim.cmd('wincmd p')
end

local function getCurrentLineText()
  local current_line = vim.api.nvim_get_current_line()
  local pattern = '%s*["\']([^"\']+)["\']'
  local captured_text = current_line:match(pattern)
  return captured_text
end

local function runJestSpec()
  local spec_name = getCurrentLineText();
  return runJest(spec_name);
end

local function runJestFile()
  return runJest(nil);
end

vim.api.nvim_create_user_command('RunPrettier', runPrettier, {})
vim.api.nvim_create_user_command('RunJest', runJestFile, {})
vim.api.nvim_create_user_command('RunJestSpec', runJestSpec, {})
vim.api.nvim_create_user_command('RunESLint', runESLint, {})
vim.api.nvim_create_user_command('RunESLintFix', runESLintFix, {})
------------------------------------------------------------------------

-- Zig commands
local function emitTestBin()
  local filename = vim.fn.expand('%')
  local command = 'zig test -femit-bin=zig-out/bin/test ' .. filename
  vim.fn.jobstart(command, {
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

vim.api.nvim_create_user_command('EmitTestBin', emitTestBin, {})
------------------------------------------------------------------------

-- Editor commands
local bot_term_buf_id = nil
local bot_term_win_id = nil
local function botTerm()
  if bot_term_win_id and vim.api.nvim_win_is_valid(bot_term_win_id) then
    vim.cmd('wincmd p')
    vim.api.nvim_win_close(bot_term_win_id, true)
    bot_term_win_id = nil
    return
  end

  if bot_term_buf_id and vim.api.nvim_buf_is_valid(bot_term_buf_id) then
    vim.cmd('bot split | b ' .. bot_term_buf_id .. ' | resize 14')
  else
    vim.cmd('bot split | resize 14 | terminal')
    bot_term_buf_id = vim.api.nvim_get_current_buf()
  end
  bot_term_win_id = vim.api.nvim_get_current_win()
  vim.cmd('startinsert')
end

local function botTermWinToggle()
  if bot_term_win_id and vim.api.nvim_win_is_valid(bot_term_win_id) then
    local current_window = vim.api.nvim_get_current_win()
    if current_window ~= bot_term_win_id then
      vim.api.nvim_set_current_win(bot_term_win_id)
      vim.cmd('startinsert')
    else
      vim.cmd('wincmd p')
    end
  else
    botTerm()
  end
end

vim.api.nvim_create_user_command('BotTerm', botTerm, {})
vim.keymap.set('t', '<A-3>', botTermWinToggle, { silent = true });
vim.keymap.set('n', '<A-3>', botTermWinToggle, { silent = true });
vim.keymap.set('n', '<A-2>', botTerm, { silent = true });
vim.keymap.set('t', '<A-2>', botTerm, { silent = true });
