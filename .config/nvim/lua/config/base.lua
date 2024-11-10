-- access to clipboard
vim.opt.clipboard='unnamedplus'

-- display line numbers
vim.opt.number = true

-- highlight search results
vim.opt.hlsearch = true

-- ignore case when searching
vim.opt.ignorecase = true

-- enable incremental search
vim.opt.incsearch = true

-- use smart case sensitivity when searching
vim.opt.smartcase = true

-- always show the status line
vim.opt.laststatus = 2

-- keep the indent of the current line
vim.opt.autoindent = true

-- display commands while typing
vim.opt.showcmd = true

-- specify the shell to use
vim.opt.shell = '/bin/zsh'

-- use spaces instead of tabs for indentation
vim.opt.expandtab = true

-- incremental substitution (neovim)
vim.opt.inccommand = 'split'

-- .exrc and .vimrc in the current directory are read
vim.o.exrc = true
