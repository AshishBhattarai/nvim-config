function RunPrettier()
    local filename = vim.fn.expand('%:p')
    local command = 'npx prettier "' .. filename .. '" --write'
    vim.fn.system(command)
end

local jest_terminal_buffer = -1
function RunJest()
  local fname = vim.fn.expand('%:p')
  local command = 'npx jest ' .. fname

  -- If terminal buffer exists, delete it
  if jest_terminal_buffer ~= -1 and vim.fn.bufexists(jest_terminal_buffer) == 1 then
    vim.api.nvim_command(jest_terminal_buffer.. 'bdelete')
  end 
  -- Open a new split terminal buffer and execute the Jest command
  vim.cmd('split | terminal ' .. command)
  jest_terminal_buffer = vim.fn.bufnr('%')
  vim.cmd('wincmd p')
end

vim.cmd('command! PrettierCurrentFile lua RunPrettier()')
vim.cmd('command! RunJest lua RunJest()')
