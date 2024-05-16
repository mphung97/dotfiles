return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    keys = {
      { "<leader>x", "<Cmd>bd<CR>" },
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        always_show_bufferline = false,
      },
    },
  },
}
