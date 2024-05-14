return {
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      { "[b", false },
      { "]b", false },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      -- local actions = require("telescope.actions")
      -- local fb_actions = require("telescope").extensions.file_browser.actions
      --
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
        prompt_prefix = "   ",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        file_ignore_patterns = { "node_modules", "package-lock.json" },
        winblend = 0,
        vimgrep_arguments = {
          "rg",
          "-L",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      })
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
