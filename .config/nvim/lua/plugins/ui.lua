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
          --   fmt = function(str)
          --     return string.lower(str):sub(1, 1)
          --   end,
          -- },
        },
        lualine_b = {
          {
            "mode",
            fmt = function(str)
              return string.lower(str)
            end,
          },
          -- {
          --   "filetype",
          --   icon_only = false,
          --   icon = { align = "right" },
          -- },
        },
        lualine_c = {
          -- {
          --   function()
          --     return require("nvim-navic").get_location()
          --   end,
          --   cond = function()
          --     return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
          --   end,
          -- },
        },
        lualine_x = {
          { "branch", icon = { "", color = { fg = "#e84855" } } },
          { show_macro_recording },
          {
            "filename",
            file_status = false,
            path = 1,
            symbols = {
              modified = "●",
              readonly = "",
              unnamed = "[No Name]",
              newfile = "",
            },
          },

          -- "diagnostics",
          -- {
          --   "diff",
          --   symbols = { added = " ", modified = " ", removed = " " },
          -- },
          -- { "searchcount", maxcount = 999, timeout = 500 },
          -- { "location", padding = { left = 0, right = 1 } },
          -- { "encoding" },
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
        },
      }

      opts.tabline = {}
      opts.winbar = {}
      opts.inactive_winbar = {}
      opts.extensions = { "neo-tree", "lazy" }
    end,
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = true,
      },
      cmdline = {
        -- view = "cmdline",
        format = {
          -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
          -- view: (default is cmdline view)
          -- opts: any options passed to the view
          -- icon_hl_group: optional hl_group for the icon
          -- title: set to anything or empty string to hide
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "󰞋" },
          input = {}, -- Used by input()
          -- lua = false, -- to disable a format, set to `false`
        },
      },
      views = {
        cmdline_popup = {
          border = {
            style = "none",
            padding = { 1, 1 },
          },
          filter_options = {},
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      },
    },
  },
  {
    "SmiteshP/nvim-navic",
    opts = {
      separator = " ",
    },
  },
  {
    "b0o/incline.nvim",
    enabled = true,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    priority = 1200,
    config = function()
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        window = {
          placement = {
            horizontal = "center",
            vertical = "top",
          },
          padding = 0,
          margin = { horizontal = 0, vertical = 0 },
        },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)

          local function get_git_diff()
            local icons = { removed = " ", changed = " ", added = " " }
            local signs = vim.b[props.buf].gitsigns_status_dict
            local labels = {}
            if signs == nil then
              return labels
            end
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
              end
            end
            if #labels > 0 then
              table.insert(labels, { " " })
            end
            return labels
          end

          local function get_diagnostic_label()
            local icons = { error = " ", warn = " ", info = " ", hint = " " }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
              end
            end
            if #label > 0 then
              table.insert(label, { " " })
            end
            return label
          end

          local function get_harpoon_items()
            local harpoon = require("harpoon")
            local marks = harpoon:list().items
            local current_file_path = vim.fn.expand("%:p:.")
            local label = {}

            for id, item in ipairs(marks) do
              if item.value == current_file_path then
                table.insert(label, { id .. " ", guifg = "#ffffff", gui = "bold" })
              else
                table.insert(label, { id .. " ", guifg = "#434852" })
              end
            end

            if #label > 0 then
              table.insert(label, 1, { "󰛢 ", guifg = "#61AfEf" })
              table.insert(label, { " " })
            end
            return label
          end

          local function get_file_name()
            local label = {}

            table.insert(label, { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" })
            table.insert(label, { filename, gui = vim.bo[props.buf].modified and "bold,italic" or "bold" })
            table.insert(label, { vim.bo[props.buf].modified and " " or "", guifg = "#ffe066" })
            if not props.focused then
              label["group"] = "BufferInactive"
            end

            return label
          end

          local function get_location()
            local label = {}
            local line = vim.fn.line(".")
            local col = vim.fn.virtcol(".")
            local location = string.format("%2d:%-2d", line, col)

            table.insert(label, { " | " })
            table.insert(label, { location .. " " })
            table.insert(label, { "", guifg = "#e84855" })

            return label
          end

          local function get_buffer_count()
            -- Initialize the label table
            local label = {}

            -- Function to count open and listed buffers
            local function count_buffers()
              local buffers = vim.api.nvim_list_bufs()
              local open_buffers = 0
              for _, buf in ipairs(buffers) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.fn.buflisted(buf) == 1 then
                  open_buffers = open_buffers + 1
                end
              end
              return open_buffers
            end

            -- Get the count of buffers
            local buffer_count = count_buffers()

            -- Insert the components into the label table
            table.insert(label, { " " .. buffer_count }) -- Buffer count
            table.insert(label, { " | " }) -- Icon

            -- Return the label table
            return label
          end

          local bg_color = "#000000"

          return {
            { "██", guifg = bg_color },
            {
              -- { get_diagnostic_label() },
              -- { get_git_diff() },
              -- { get_harpoon_items() },
              { get_buffer_count() },
              { get_file_name() },
              { get_location() },
              guibg = bg_color,
            },
            { "██", guifg = bg_color },
          }
        end,
      })
    end,
  },
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },
  {
    "preservim/vim-pencil",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
}
