return {
  'preservim/nerdtree',
  config = function()
    local std_in = nil

    -- Start NERDTree when Vim is started without file arguments.
    vim.api.nvim_create_autocmd("StdinReadPre", {
        pattern = "*",
        callback = function()
            std_in = 1
        end,
    })

    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function()
            if vim.fn.argc() == 0 and std_in == nil then
                vim.cmd("NERDTree")
            end
        end,
    })

    -- Exit Vim if NERDTree is the only window remaining in the only tab.
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 then
                local nerdtree = vim.b.NERDTree
                if nerdtree and nerdtree.isTabTree and nerdtree.isTabTree() then
                    vim.cmd("quit")
                end
            end
        end,
    })

    -- Close the tab if NERDTree is the only window remaining in it.
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            if vim.fn.winnr('$') == 1 then
                local nerdtree = vim.b.NERDTree
                if nerdtree and nerdtree.isTabTree and nerdtree.isTabTree() then
                    vim.cmd("quit")
                end
            end
        end,
    })

    -- show hidden files in NERDTree
    vim.g.NERDTreeShowHidden = 1

    -- key mapping for nerdtree
    vim.keymap.set('n', '<leader>n', ':NERDTreeFocus<CR>', { silent = true })
    vim.keymap.set('n', '<C-n>', ':NERDTree<CR>', { silent = true })
    vim.keymap.set('n', '<C-t>', ':NERDTreeToggle<CR>', { silent = true })
    vim.keymap.set('n', '<C-f>', ':NERDTreeFind<CR>', { silent = true })

    -- key mapping for tab
    vim.keymap.set('n', 'te', ':tabedit ', { silent = false })
    vim.keymap.set('n', '<S-Tab>', ':tabprev<CR>', { silent = true })
    vim.keymap.set('n', '<Tab>', ':tabnext<CR>', { silent = true })
  end,
  dependencies = {
    'ryanoasis/vim-devicons',
    'kyazdani42/nvim-web-devicons'
  }
}
