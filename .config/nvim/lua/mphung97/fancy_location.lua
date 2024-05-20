local M = require("lualine.component"):extend()

function M:init(options)
    options.icon = options.icon or { " ", color = { fg = "#1e66f5" }, align = "right" }
    M.super.init(self, options)
end

function M:update_status()
    local line = vim.fn.line(".")
    local col = vim.fn.virtcol(".")
    return string.format('%d:%d', line, col)
end

return M
