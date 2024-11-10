-- Memo command
vim.api.nvim_create_user_command('Memo', function()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.8)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
    title = '  ~/.memo.md  ',
    title_pos = 'center',
  })
  vim.cmd('edit ~/.memo.md')
end, {})
