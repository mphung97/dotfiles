local M = require("lualine.components.branch"):extend()

function M:init(options)
  options.icon = options.icon or { "", color = { fg = "#f38ba8" } }
  M.super.init(self, options)
end

return M
