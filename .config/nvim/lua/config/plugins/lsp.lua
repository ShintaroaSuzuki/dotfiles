return {
  {
    "prabirshrestha/vim-lsp",
    config = function()
      vim.g.lsp_settings = {
        ['pylsp-all'] = {
          workspace_config = {
            pylsp = {
              configurationSources = {'flake8'},
              plugins = {
                flake8 = {
                  enabled = true
                },
                mccabe = {
                  enabled = false
                },
                pycodestyle = {
                  enabled = false
                },
                pyflakes = {
                  enabled = false
                },
                pylsp_mypy = {
                  enabled = true
                }
              }
            }
          }
        }
      }
      vim.g.lsp_settings_filetype_go = {'gopls', 'golangci-lint-langserver'}
      vim.api.nvim_set_keymap('n', '<C-j>', ':LspNextError<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<S-C-j>', ':LspPreviousError<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-k>', ':LspHover<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-l>', ':LspDocumentDiagnostics<CR>', { noremap = true, silent = true })
    end
  },
  {
    "mattn/vim-lsp-settings",
    dependencies = { "prabirshrestha/vim-lsp" },
  },
  {
    "mattn/vim-lsp-icons",
    dependencies = { "prabirshrestha/vim-lsp" },
  },
  {
    "prabirshrestha/asyncomplete.vim",
  },
  {
    "prabirshrestha/asyncomplete-lsp.vim",
    dependencies = { "prabirshrestha/vim-lsp", "prabirshrestha/asyncomplete.vim" },
  },
}
