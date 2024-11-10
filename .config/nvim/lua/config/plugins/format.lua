return {
  {
    "prettier/vim-prettier",
    ft = {"javascript", "typescript", "css", "less", "scss", "json", "graphql", "markdown", "vue", "svelte", "yaml", "html", "astro"},
    build = "yarn install --frozen-lockfile --production",
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = {"*.js","*.jsx","*.mjs","*.ts","*.tsx","*.css","*.less","*.scss","*.json","*.graphql","*.md","*.vue","*.svelte","*.yml","*.yaml","*.html","*.astro"},
        command = "PrettierAsync",
      })
    end,
  },
  {
    "fatih/vim-go",
    ft = "go",
    build = ":GoUpdateBinaries",
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        command = "GoFmt",
      })
    end,
  },
  {
    "daixiang0/gci",
    ft = "go",
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          vim.cmd("silent !gci write " .. vim.fn.expand("%"))
        end,
      })
    end,
  },
  {
    "psf/black",
    branch = "stable",
    ft = "python",
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
          vim.cmd("Black")
        end,
      })
    end,
  },
}
