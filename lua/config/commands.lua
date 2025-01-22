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


-- Neorg git sync
vim.api.nvim_create_user_command('NeorgSync', function()
  local repo_path = vim.env.NEORG_NOTES_REPO
  if not repo_path then
    vim.notify("NEORG_NOTES_REPO environment variable is not set!", vim.log.levels.ERROR)
    return
  end

  -- Get current datetime
  local datetime = os.date("%Y-%m-%d %H:%M:%S")

  -- Define Git commands
  local function git_command(args, callback)
    vim.system({ "git", "-C", repo_path, unpack(args) }, { text = true }, function(result)
      if callback then callback(result) end
    end)
  end

  -- Step 1: Pull with rebase
  git_command({ "pull", "--rebase" }, function(result)
    if string.find(result.stdout, "CONFLICT") then
      vim.schedule(function()
        vim.notify("Git rebase conflict detected! Resolve conflicts before syncing.", vim.log.levels.ERROR)
      end)
      return
    end

    -- Step 2: Check if there are any changes
    git_command({ "status", "--porcelain" }, function(status_result)
      if status_result.stdout == "" then
        vim.schedule(function()
          vim.notify("No changes to sync.", vim.log.levels.INFO)
        end)
        return
      end

      -- Step 3: Stage, commit, and push
      git_command({ "add", "." }, function()
        git_command({ "commit", "-m", "syncing notes " .. datetime }, function(commit_result)
          if string.find(commit_result.stdout, "nothing to commit") then
            vim.schedule(function()
              vim.notify("No changes to commit.", vim.log.levels.INFO)
            end)
            return
          end
          git_command({ "push", "origin", "main" }, function()
            vim.schedule(function()
              vim.notify("Neorg notes synced successfully!", vim.log.levels.INFO)
            end)
          end)
        end)
      end)
    end)
  end)
end, {})
