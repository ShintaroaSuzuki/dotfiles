return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    'tpope/vim-surround',
    'junegunn/vim-easy-align',
    config = function()
      vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', { noremap = false, silent = true })
      vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', { noremap = false, silent = true })
    end,
    't9md/vim-quickhl',
    config = function()
        vim.keymap.set('n', '<Space>h', '<Plug>(quickhl-manual-this)', { noremap = false, silent = true })
        vim.keymap.set('x', '<Space>h', '<Plug>(quickhl-manual-this)', { noremap = false, silent = true })
        vim.keymap.set('n', '<Space>H', '<Plug>(quickhl-manual-reset)', { noremap = false, silent = true })
    end,
    'kshenoy/vim-signature',
    config = function()
        vim.g.SignatureMap = {
            ['Leader'] = "m",
            ['PlaceNextMark'] = "",
            ['ToggleMarkAtLine'] = "<Space>m",
            ['PurgeMarksAtLine'] = "",
            ['DeleteMark'] = "",
            ['PurgeMarks'] = "",
            ['PurgeMarkers'] = "",
            ['GotoNextLineAlpha'] = "",
            ['GotoPrevLineAlpha'] = "",
            ['GotoNextSpotAlpha'] = "",
            ['GotoPrevSpotAlpha'] = "",
            ['GotoNextLineByPos'] = "",
            ['GotoPrevLineByPos'] = "",
            ['GotoNextSpotByPos'] = "",
            ['GotoPrevSpotByPos'] = "",
            ['GotoNextMarker'] = "",
            ['GotoPrevMarker'] = "",
            ['GotoNextMarkerAny'] = "",
            ['GotoPrevMarkerAny'] = "",
            ['ListBufferMarks'] = "",
            ['ListBufferMarkers'] = ""
        }
        vim.g.SignatureIncludeMarks = "abcdefghijklmnopqrstuvwxyz"
    end,
}
