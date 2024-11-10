return {
  'yggdroot/indentline',
  config = function()
    vim.g.indentLine_enabled = 1
    vim.g.indentLine_char = '¦'
    vim.g.indentLine_leadingSpaceEnabled = 1
    vim.g.indentLine_leadingSpaceChar = '.'
    vim.g.indentLine_fileTypeExclude = { 'nerdtree' }
    vim.g.indentLine_bufTypeExclude = { 'terminal' }
    vim.g.indentLine_showFirstIndentLevel = 1
    vim.g.indentLine_color_term = 239
    vim.g.indentLine_color_gui = '#4A5366'
  end
}
