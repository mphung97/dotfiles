return {
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      { "nvim-telescope/telescope-file-browser.nvim" },
    },
    keys = {
      { "[b", false },
      { "]b", false },
      {
        "<leader>/",
        function()
          local telescope = require("telescope")

          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            select_buffer = true,
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            layout_config = { height = 0.7, width = 0.5 },
          })
        end,
        desc = "Open File Browser with the path of the current buffer",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      -- local fb_actions = require("telescope").extensions.file_browser.actions
      --
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
        prompt_prefix = "   ",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        file_ignore_patterns = { "node_modules/*", "package-lock.json" },
        winblend = 0,
        -- vimgrep_arguments = {
        --   "rg",
        --   "-L",
        --   "--color=never",
        --   "--no-heading",
        --   "--with-filename",
        --   "--line-number",
        --   "--column",
        --   "--smart-case",
        -- },
      })
      opts.pickers = {
        grep_string = {
          previewer = true,
          file_ignore_patterns = {},
        },
        live_grep = {
          previewer = false,
          file_ignore_patterns = {},
        },
        buffers = {
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer,
            },
            n = {
              ["<c-d>"] = actions.delete_buffer,
            },
          },
          previewer = false,
          initial_mode = "normal",
          layout_config = {
            height = 0.4,
            width = 0.6,
            prompt_position = "top",
            preview_cutoff = 120,
          },
        },
      }
      opts.extensions = {
        file_browser = {
          git_status = false,
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            ["i"] = {},
            ["n"] = {},
          },
          dir_icon = "",
        },
      }
      telescope.setup(opts)
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end,
  },
}
