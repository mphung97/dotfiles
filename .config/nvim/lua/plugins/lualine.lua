return {
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
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
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
        lualine_a = {
          {
            "fileformat",
            symbols = {
              unix = "󰌽",
              dos = "",
              mac = "",
            },
          },
        },
        lualine_b = {
          {
            "buffers",
            mode = 1,
            hide_filename_extension = true,
            use_mode_colors = true,
            show_modified_status = false,
            symbols = {
              modified = " ●", -- Text to show when the buffer is modified
              alternate_file = "", -- Text to show to identify the alternate file
              directory = "", -- Text to show when the buffer is a directory
            },
          },
          -- "branch",
        },
        lualine_c = {
          {
            "filename",
            symbols = {
              modified = "",
              readonly = "",
              unnamed = "[No Name]",
              newfile = "",
            },
          },
        },
        lualine_x = {
          { show_macro_recording },
          "diagnostics",
          { "diff", symbols = { added = " ", modified = " ", removed = " " } },
          { "searchcount", maxcount = 999, timeout = 500 },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_y = {
          { "mode" },
        },
        lualine_z = {
          -- { "filetype", icon_only = true },
          "encoding",
        },
      }

      opts.tabline = {}
      opts.winbar = {}
      opts.inactive_winbar = {}
      opts.extensions = { "neo-tree", "lazy" }
    end,
  },
}
