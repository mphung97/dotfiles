return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        always_show_bufferline = true,
        show_buffer_close_icons = false,
      },
    },
  },
}
