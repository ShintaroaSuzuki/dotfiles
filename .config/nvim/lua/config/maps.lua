-- split window
vim.api.nvim_set_keymap('n', 'ss', ':split<CR><C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'sv', ':vsplit<CR><C-w>w', { noremap = true, silent = true })

-- move window
vim.api.nvim_set_keymap('n', '<Space>', '<C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', 's<left>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', 's<up>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', 's<down>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', 's<right>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', 'sh', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', 'sk', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', 'sj', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', 'sl', '<C-w>l', { noremap = true, silent = true })

-- resize window
vim.api.nvim_set_keymap('n', '<C-w><left>', '<C-w><', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-w><right>', '<C-w>>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-w><up>', '<C-w>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-w><down>', '<C-w>-', { noremap = true, silent = true })

-- select all
vim.keymap.set('n', '<C-a>', 'ggVG', { noremap = true })

-- relativenumber toggle
vim.keymap.set('n', '<leader>rn', ':set relativenumber!<CR>', { noremap = true })
