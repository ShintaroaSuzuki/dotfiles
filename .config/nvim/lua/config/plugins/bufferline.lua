return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "kyazdani42/nvim-web-devicons",
  config = function()
    -- 常にタブラインを表示
    vim.opt.showtabline = 2

    local nb = require("config.nb")

    require("bufferline").setup({
      options = {
        mode = "buffers",
        separator_style = { "", "" },
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = true,
        diagnostics = "nvim_lsp",
        name_formatter = function(buf)
          local title = nb.get_title(buf.path)
          return title or buf.name
        end,
        offsets = {
          {
            filetype = "NERDTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    })

    -- キーマッピング
    vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { silent = true })
    vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { silent = true })
    vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { silent = true })
    vim.keymap.set("n", "<leader>bc", "<cmd>BufferLinePickClose<CR>", { silent = true })

  end,
}
