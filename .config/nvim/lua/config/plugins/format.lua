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
    -- config = function()
    --   vim.api.nvim_create_autocmd("BufWritePost", {
    --     pattern = "*.py",
    --     callback = function()
    --         vim.cmd("silent !uvx black --quiet %")            
    --         vim.cmd("edit")
    --     end,
    --   })
    -- end,
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local filename = vim.api.nvim_buf_get_name(buf)
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          local content = table.concat(lines, "\n")
          
          local formatted = vim.fn.system("uvx black --quiet -", content)
          
          if vim.v.shell_error == 0 then
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(formatted, "\n"))
          else
            vim.notify("Black formatting failed", vim.log.levels.WARN)
          end
        end,
      })
    end,
  },
}
