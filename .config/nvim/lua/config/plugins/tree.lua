return {
  'preservim/nerdtree',
  config = function()
    -- show hidden files in NERDTree
    vim.g.NERDTreeShowHidden = 1

    -- key mapping for nerdtree
    vim.keymap.set('n', '<leader>nt', ':NERDTreeFocus<CR>', { silent = true })
    vim.keymap.set('n', '<C-n>', ':NERDTree<CR>', { silent = true })
    vim.keymap.set('n', '<C-t>', ':NERDTreeToggle<CR>', { silent = true })
    vim.keymap.set('n', '<C-f>', ':NERDTreeFind<CR>', { silent = true })
  end,
  dependencies = {
    'ryanoasis/vim-devicons',
    'kyazdani42/nvim-web-devicons'
  }
}
