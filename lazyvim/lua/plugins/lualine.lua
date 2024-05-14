return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "meuter/lualine-so-fancy.nvim",
    },
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = function(_, opts)
      vim.api.nvim_create_autocmd("RecordingEnter", {
        callback = function()
          require("lualine").refresh({
            place = { "statusline" },
          })
        end,
      })

      vim.api.nvim_create_autocmd("RecordingLeave", {
        callback = function()
          local timer = vim.loop.new_timer()
          timer:start(
            50,
            0,
            vim.schedule_wrap(function()
              require("lualine").refresh({
                place = { "statusline" },
              })
            end)
          )
        end,
      })

      opts.options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "⎪", right = "⎪" },
        section_separators = { left = "█", right = "█" },
        disabled_filetypes = {
          inactive_winbar = {},
          statusline = { "alpha", "dashboard", "fzf", "lazy", "mason", "TelescopePrompt" },
          tabline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      }

      opts.sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "fancy_branch",
          "fancy_diff",
          { "fancy_diagnostics", sources = { "nvim_lsp" }, symbols = { error = " ", warn = " ", info = " " } },
        },
        lualine_c = {
          { "fancy_cwd", substitute_home = true },
        },
        lualine_x = {
          { "fancy_macro" },
          { "fancy_searchcount" },
          { "fancy_location" },
        },
        lualine_y = {},
        lualine_z = {
          { "fancy_lsp_servers" },
          { "fancy_filetype", ts_icon = "" },
        },
      }

      opts.tabline = {}
      opts.winbar = {}
      opts.inactive_winbar = {}
      opts.extensions = { "neo-tree", "lazy" }
    end,
  },
}
