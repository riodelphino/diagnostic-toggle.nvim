local M = {}

---@param style_name string?
function M.toggle_style(style_name)
  local opts = require("diagnostic-toggle.config").options
  if style_name then
    opts.current.style = style_name
  else
    local toggle_map = opts.toggle.styles
    opts.current.style = toggle_map[opts.current.style]
  end
  vim.diagnostic.config(opts.styles[opts.current.style])
end

---@param format_name string?
function M.toggle_format(format_name)
  local opts = require("diagnostic-toggle.config").options
  if format_name then
    opts.current.format = format_name
  else
    local toggle_map = opts.toggle.formats
    opts.current.format = toggle_map[opts.current.format]
  end
  vim.diagnostic.show()
end

---@param severity_name string?
function M.toggle_severity(severity_name)
  local opts = require("diagnostic-toggle.config").options
  if severity_name then
    opts.current.severity = severity_name
  else
    local toggle_map = opts.toggle.severities
    opts.current.severity = toggle_map[opts.current.severity]
  end
  vim.diagnostic.show()
end

return M
