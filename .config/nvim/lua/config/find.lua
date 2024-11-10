-- settings for the :find command

-- finding files - search down into subfolders
vim.opt.path:append('**')

-- ignore files in node_modules during file operations
vim.opt.wildignore:append('*/node_modules/*')

