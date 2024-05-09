return {
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      -- "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      -- {
      --   "sf",
      --   function()
      --     local telescope = require("telescope")
      --
      --     -- local function telescope_buffer_dir()
      --     --   return vim.fn.expand("%:p:h")
      --     -- end
      --
      --     telescope.extensions.file_browser.file_browser({
      --       path = "%:p:h",
      --       -- cwd = telescope_buffer_dir(),
      --       respect_gitignore = false,
      --       hidden = true,
      --       grouped = true,
      --       previewer = false,
      --       initial_mode = "normal",
      --       layout_config = { height = 40, prompt_position = "top" },
      --     })
      --   end,
      --   desc = "Open File Browser with the path of the current buffer",
      -- },
      { "[b", false },
      { "]b", false },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      -- local actions = require("telescope.actions")
      -- local fb_actions = require("telescope").extensions.file_browser.actions
      opts.pickers = {
        grep_string = {
          file_ignore_patterns = { "node_modules/*", "pnpm-lock.yaml", "package-lock.json" },
        },
      }
      opts.extensions = {
        -- file_browser = {
        --   -- theme = "dropdown",
        --   -- disables netrw and use telescope-file-browser in its place
        --   hijack_netrw = true,
        --   mappings = {
        --     -- your custom insert mode mappings
        --     ["n"] = {},
        --   },
        -- },
      }
      telescope.setup(opts)
      require("telescope").load_extension("fzf")
      -- require("telescope").load_extension("file_browser")
    end,
  },
}
