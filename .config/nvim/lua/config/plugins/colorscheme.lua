return { 
  -- "catppuccin/nvim",
  -- name = "catppuccin",
  "projekt0n/github-nvim-theme",
  name = "github-theme",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "github_dark"
    if vim.fn.exists("&termguicolors") == 1 and vim.fn.exists("&winblend") == 1 then
      vim.cmd("syntax enable")
      vim.o.termguicolors = true
      vim.o.winblend = 20
      vim.o.wildoptions = "pum"
      vim.o.pumblend = 20

      local bg_back = " guibg=NONE ctermbg=NONE"
      local fmt_none = " gui=NONE cterm=NONE,underline"
      local fg_base0 = " guifg=NONE ctermfg=NONE"

      vim.cmd("hi! Normal" .. fmt_none .. fg_base0 .. bg_back)
      vim.cmd("hi! NonText" .. fmt_none .. fg_base0 .. bg_back)
      vim.cmd("hi! Folded" .. fmt_none .. fg_base0 .. bg_back)
      vim.cmd("hi! NormalNC" .. fmt_none .. fg_base0 .. bg_back)
      vim.cmd("hi! SignColumn" .. fmt_none .. fg_base0 .. bg_back)
      vim.cmd("hi! VertSplit" .. fmt_none .. fg_base0 .. bg_back)
      vim.cmd("hi! StatusLine" .. fmt_none .. fg_base0 .. bg_back)
      vim.cmd("hi! StatusLineNC" .. fmt_none .. fg_base0 .. bg_back)
      vim.cmd("hi! TabLineFill" .. fmt_none .. fg_base0 .. bg_back)
    end
  end,
}
