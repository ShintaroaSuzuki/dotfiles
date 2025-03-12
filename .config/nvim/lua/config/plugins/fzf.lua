return {
  {
    "junegunn/fzf",
    build = ":call fzf#install()"
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    config = function()
      vim.api.nvim_set_keymap('n', 'ff', ':Files<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'fg', ':Rg<CR>', { noremap = true, silent = true })
    end
  }
}

