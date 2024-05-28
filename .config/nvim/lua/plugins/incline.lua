return {
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
          -- cursorline = true,
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
                table.insert(label, { id .. " ", guifg = "#FFFFFF", gui = "bold" })
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
            table.insert(label, { vim.bo[props.buf].modified and " " or "", guifg = "#d19a66" })
            table.insert(label, { filename, gui = vim.bo[props.buf].modified and "bold,italic" or "bold" })
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

            table.insert(label, { "  " })
            table.insert(label, { location .. " " })
            table.insert(label, { " ", guifg = "#f38ba8" })

            return label
          end

          local bg_color = "#000000"

          return {
            { "█", guifg = bg_color },
            {
              { get_diagnostic_label() },
              { get_git_diff() },
              { get_harpoon_items() },
              { get_file_name() },
              { get_location() },
              guibg = bg_color,
            },
            { "█", guifg = bg_color },
          }
        end,
      })
    end,
  },
}
