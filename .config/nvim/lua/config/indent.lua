-- indentation settings
vim.cmd('filetype plugin indent on')

-- set shift width to 2
vim.opt.shiftwidth = 2

-- set tab width to 2
vim.opt.tabstop = 2

-- enable auto indent
vim.opt.autoindent = true

-- enable smart indent
vim.opt.smartindent = true

-- disable line wrapping
vim.opt.wrap = false  -- No wrap lines

-- configure backspace behavior
vim.opt.backspace = { 'start', 'eol', 'indent' }
