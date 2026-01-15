return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup({
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        position = 'left',
        width = 30,
        mappings = {
          ['<space>'] = 'none',
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = '',
          expander_expanded = '',
        },
        git_status = {
          symbols = {
            added = '✚',
            modified = '',
            deleted = '✖',
            renamed = '󰁕',
            untracked = '',
            ignored = '',
            unstaged = '󰄱',
            staged = '',
            conflict = '',
          },
        },
      },
    })

    -- Transparent background
    vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = 'NONE' })
    -- File colors
    vim.api.nvim_set_hl(0, 'NeoTreeFileName', { fg = '#d0e8f0' })        -- 通常ファイル: 薄い青
    vim.api.nvim_set_hl(0, 'NeoTreeGitModified', { fg = '#88c0d0', bold = true })  -- 変更ファイル: はっきりした青
    vim.api.nvim_set_hl(0, 'NeoTreeGitUntracked', { fg = '#5e81ac' })              -- 未追加ファイル: 青

    -- Key mappings (preserving original shortcuts)
    vim.keymap.set('n', '<leader>nt', ':Neotree focus<CR>', { silent = true, desc = 'Focus Neo-tree' })
    vim.keymap.set('n', '<C-n>', ':Neotree show<CR>', { silent = true, desc = 'Show Neo-tree' })
    vim.keymap.set('n', '<C-t>', ':Neotree toggle<CR>', { silent = true, desc = 'Toggle Neo-tree' })
    vim.keymap.set('n', '<C-f>', ':Neotree reveal<CR>', { silent = true, desc = 'Reveal file in Neo-tree' })
  end,
}
