return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
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
        theme = "catppuccin",
        component_separators = { left = "", right = "│" },
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
          -- {
          --   "fileformat",
          --   symbols = {
          --     unix = "󰌽",
          --     dos = "",
          --     mac = "",
          --   },
          -- },
          -- {
          --   "mode",
          -- },
          { require("mphung97.fancy_mode") },
        },
        lualine_b = {
          -- {
          --   "filetype",
          --   icon_only = false,
          --   icon = { align = "right" },
          -- },
          { require("mphung97.fancy_branch") },
        },
        lualine_c = {
          {
            "filename",
            file_status = true,
            symbols = {
              modified = "●",
              readonly = "",
              unnamed = "[No Name]",
              newfile = "",
            },
          },
          -- { require("mphung97.fancy_cwd") },
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end,
          },
        },
        lualine_x = {
          { show_macro_recording },
          "diagnostics",
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
          { "searchcount", maxcount = 999, timeout = 500 },
          -- { "location", padding = { left = 0, right = 1 } },
          { "encoding" },
          { require("mphung97.fancy_filetype") },
        },
        lualine_y = {
          -- { "mode" },
          -- {
          --   "buffers",
          --   mode = 1,
          --   icons_enabled = false,
          --   hide_filename_extension = true,
          --   use_mode_colors = true,
          --   show_modified_status = true,
          --   symbols = {
          --     modified = " ●", -- Text to show when the buffer is modified
          --     alternate_file = "", -- Text to show to identify the alternate file
          --     directory = "", -- Text to show when the buffer is a directory
          --   },
          --   section_separators = { left = "", right = "█" },
          -- },
        },
        lualine_z = {
          -- { "branch" },
          { require("mphung97.fancy_location") },
        },
      }

      opts.tabline = {}
      opts.winbar = {}
      opts.inactive_winbar = {}
      opts.extensions = { "neo-tree", "lazy" }
    end,
  },
}
