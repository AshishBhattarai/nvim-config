local function delete_buffer(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match(name) then
      vim.api.nvim_buf_delete(buf, { force = true })
      return
    end
  end
end


-- JS tool commands
------------------------------------------------------------------------
vim.g.js_test_runner = 'pnpm jest '
vim.g.js_format_runner = 'pnpm prettier '
vim.g.js_lint_runner = 'pnpm eslint '
local function runPrettier()
  local file_path = vim.fn.expand('%')
  local command = vim.g.js_format_runner .. '"' .. file_path .. '" --write'
  vim.cmd("w")
  vim.fn.system(command)
  vim.cmd("e")
end

local function runESLintFix()
  local file_path = vim.fn.expand('%')
  local command = vim.g.js_lint_runner .. '"' .. file_path .. '" --fix'
  vim.cmd("w")
  vim.fn.system(command)
  vim.cmd("e")
end

local js_terminal_buffer = nil
local function openJSTerminalWithCommand(command, name)
  local cwd = vim.fn.getcwd()
  local original_win = vim.api.nvim_get_current_win()
  local target_win = nil

  -- Handle existing terminal buffer
  if js_terminal_buffer and vim.api.nvim_buf_is_valid(js_terminal_buffer) then
    local win_ids = vim.fn.win_findbuf(js_terminal_buffer)
    if #win_ids > 0 then
      target_win = win_ids[1]
      vim.api.nvim_set_current_win(target_win)
      local tmp_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_win_set_buf(target_win, tmp_buf)
    end
    vim.api.nvim_buf_delete(js_terminal_buffer, { force = true })
  end

  -- Create new split and terminal
  if not (target_win and vim.api.nvim_win_is_valid(target_win)) then
    delete_buffer(name)
    vim.cmd("split")
    target_win = vim.api.nvim_get_current_win()
    local term_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(target_win, term_buf)
  end

  vim.fn.termopen(command, { cwd = cwd })

  js_terminal_buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(js_terminal_buffer, name)

  -- Return focus to original window
  vim.api.nvim_set_current_win(original_win)
end

local function runESLint()
  local file_path = vim.fn.expand('%')
  local file_name = vim.fn.fnamemodify(file_path, ':t')
  local command = vim.g.js_lint_runner .. file_path
  openJSTerminalWithCommand(command, "Lint " .. file_name)
end

local function runJest(spec_name)
  local file_path = vim.fn.expand('%:p')
  local file_name = vim.fn.fnamemodify(file_path, ':t')
  local test_opts = spec_name and ' -t "' .. spec_name .. '"' or ''
  local command = vim.g.js_test_runner .. '"' .. file_path .. '"' .. test_opts
  openJSTerminalWithCommand(command, "Spec " .. file_name)
end

local function getCurrentLineText()
  local current_line = vim.api.nvim_get_current_line()
  local pattern = '%s*["\']([^"\']+)["\']'
  local captured_text = current_line:match(pattern)
  return captured_text
end

local function runJestSpec()
  local spec_name = getCurrentLineText()
  return runJest(spec_name)
end

local function runJestFile()
  return runJest(nil)
end

vim.api.nvim_create_user_command('RunPrettier', runPrettier, {})
vim.api.nvim_create_user_command('RunJest', runJestFile, {})
vim.api.nvim_create_user_command('RunJestSpec', runJestSpec, {})
vim.api.nvim_create_user_command('RunESLint', runESLint, {})
vim.api.nvim_create_user_command('RunESLintFix', runESLintFix, {})
------------------------------------------------------------------------

-- Editor commands
vim.g.bot_term_size = '14'
local bot_term_buf_id = nil
local bot_term_win_id = nil
local function botTerm()
  -- have valid window id and buffer id
  if bot_term_win_id and vim.api.nvim_win_is_valid(bot_term_win_id) then
    vim.cmd('wincmd p')
    vim.api.nvim_win_close(bot_term_win_id, true)
    bot_term_win_id = nil
    return
  end

  -- only have valid buffer id
  if bot_term_buf_id and vim.api.nvim_buf_is_valid(bot_term_buf_id) then
    vim.cmd('bot split | b ' .. bot_term_buf_id .. ' | resize ' .. vim.g.bot_term_size)
  else
    -- start a new terminal
    delete_buffer('BotTermX')
    vim.cmd('bot split | resize ' .. vim.g.bot_term_size .. ' | terminal')
    vim.cmd('setlocal nospell')
    bot_term_buf_id = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(bot_term_buf_id, "BotTermX")
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
vim.keymap.set('t', '<A-3>', botTermWinToggle, { silent = true })
vim.keymap.set('n', '<A-3>', botTermWinToggle, { silent = true })
vim.keymap.set('n', '<A-2>', botTerm, { silent = true })
vim.keymap.set('t', '<A-2>', botTerm, { silent = true })


-- Running shell commands in split
local cmd_shell = vim.env.SHELL or "/bin/bash"
vim.g.shell_split_cmd = 'split'
local function runShellCommand(opts)
  vim.cmd(vim.g.shell_split_cmd .. " | terminal " .. cmd_shell .. " -l -c " .. opts.args)
end

vim.api.nvim_create_user_command("Sh", runShellCommand, {
  nargs = 1,
  desc = "Run shell command"
})


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
      if result.code ~= 0 then
        local err = result.stderr or "Unknown error"
        vim.schedule(function()
          vim.notify("Sync Failed: " .. err, vim.log.levels.ERROR)
        end)
      elseif callback then
        callback(result)
      end
    end)
  end

  local function git_pull_rebase(callback)
    git_command({ "pull", "origin", "main", "--rebase" }, function(result)
      if string.find(result.stdout, "CONFLICT") then
        vim.schedule(function()
          vim.notify("Git rebase conflict detected! Resolve conflicts before syncing.", vim.log.levels.ERROR)
        end)
      else
        if string.find(result.stdout, "Fast%-forward") then
          vim.schedule(function()
            vim.notify("Neorg notes pulled successfully", vim.log.levels.INFO)
          end)
        end
        if callback then callback() end
      end
    end)
  end

  -- Step 2: Check if there are any changes
  git_command({ "status", "--porcelain" }, function(status_result)
    if status_result.stdout == "" then
      vim.schedule(function()
        vim.notify("No changes to commit.", vim.log.levels.INFO)
      end)
      git_pull_rebase()
    else
      git_command({ "add", "." }, function()
        git_command({ "commit", "-m", "syncing notes " .. datetime }, function(commit_result)
          -- no changes to commit
          if string.find(commit_result.stdout, "nothing to commit") then
            vim.schedule(function()
              vim.notify("No changes to commit.", vim.log.levels.INFO)
            end)
          end
          -- rebase and then push
          git_pull_rebase(function()
            -- Call push anyway if we get to this point
            git_command({ "push", "origin", "main" }, function(push_result)
              if string.find(push_result.stdout, "Everything up-to-date") then
                vim.schedule(function()
                  vim.notify("Everything up-to-date", vim.log.levels.INFO)
                end)
              else
                vim.schedule(function()
                  vim.notify("Neorg notes pushed successfully!", vim.log.levels.INFO)
                end)
              end
            end)
          end)
        end)
      end)
    end
  end)
end, {})
