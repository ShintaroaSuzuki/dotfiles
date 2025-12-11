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
        separator_style = "slant",
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

    -- 新しいバッファを開いた時にNERDTreeが閉じていたら開く
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*",
      callback = function()
        -- NERDTree自体は除外
        if vim.bo.filetype == "nerdtree" then
          return
        end
        -- 特殊バッファは除外（ヘルプ、ターミナル等）
        if vim.bo.buftype ~= "" then
          return
        end
        -- NERDTreeが閉じていたら開く
        if vim.fn.bufwinnr("NERD_tree") == -1 then
          vim.cmd("NERDTree")
          vim.cmd("wincmd p")
        end
      end,
    })
  end,
}
