return {
  {
    "b0o/incline.nvim",
    enabled = false,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    priority = 1200,
    config = function()
      -- local helpers = require("incline.helpers")
      -- local navic = require("nvim-navic")
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        window = {
          placement = {
            horizontal = "right",
            vertical = "top",
          },
          padding = 0,
          margin = { horizontal = 0, vertical = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local function get_file_name()
            local label = {}
            table.insert(label, { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" })
            table.insert(label, { vim.bo[props.buf].modified and " " or "", guifg = "none" })
            table.insert(label, { filename, gui = vim.bo[props.buf].modified and "bold,italic" or "bold" })
            if not props.focused then
              label["group"] = "BufferInactive"
            end

            return label
          end
          return {
            { get_file_name() },
          }
        end,
      })
    end,
  },
}
