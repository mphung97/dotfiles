return {
  -- theme
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    }
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    enabled = true,
    keys = {
      { "<leader>x", "<Cmd>bw<CR>" },
      { "<Tab>",     "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>",   "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        always_show_bufferline = true
      }
    }
  },

  -- filename
  {
    "b0o/incline.nvim",
    enabled = false,
    dependencies = {},
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local helpers = require("incline.helpers")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local buffer = {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) }
            or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#363944",
          }
          return buffer
        end,
      })
    end,
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = function(_, opts)
      local function show_macro_recording()
        local recording_register = vim.fn.reg_recording()
        if recording_register == "" then
          return ""
        else
          return "Recording @" .. recording_register
        end
      end

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
          statusline = { "alpha", "dashboard", "fzf", "lazy", "mason", "TelescopePrompt", },
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
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {
          { show_macro_recording, },
          { "progress",           separator = " ",                  padding = { left = 1, right = 0 } },
          { "location",           padding = { left = 0, right = 1 } },
        },
        lualine_y = { "fileformat", "filetype" },
        lualine_z = { "encoding" },
      }

      opts.tabline = {}
      opts.winbar = {}
      opts.inactive_winbar = {}
      opts.extensions = { "neo-tree", "lazy" }
    end,
  },
}
