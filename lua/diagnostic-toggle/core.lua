local util = require("diagnostic-toggle.util")

local M = {}

---Toggle or set style
---@param style_name string?
function M.toggle_style(style_name)
  local opts = require("diagnostic-toggle.config").options
  if not style_name then
    local toggle_map = opts.sequences.styles
    style_name = toggle_map[opts.current.style]
  end
  opts.current.style = style_name
  M.apply_diagnostic_config()
  util.notify_on_toggle("style", style_name)
end

---Toggle or set format
---@param format_name string?
function M.toggle_format(format_name)
  local opts = require("diagnostic-toggle.config").options
  if not format_name then
    local toggle_map = opts.sequences.formats
    format_name = toggle_map[opts.current.format]
  end
  opts.current.format = format_name
  M.apply_diagnostic_config()
  util.notify_on_toggle("format", format_name)
end

---Toggle or set severity
---@param severity_name string?
function M.toggle_severity(severity_name)
  local opts = require("diagnostic-toggle.config").options
  if not severity_name then
    local toggle_map = opts.sequences.severities
    severity_name = toggle_map[opts.current.severity]
  end
  opts.current.severity = severity_name
  M.apply_diagnostic_config()
  util.notify_on_toggle("severity", severity_name)
end

---Apply all current style/format/severity to diagnostic config
function M.apply_diagnostic_config()
  local opts = require("diagnostic-toggle.config").options
  local style = vim.deepcopy(opts.styles[opts.current.style])
  -- Replace format and severity dynamically
  for _, target in ipairs({ "virtual_text", "virtual_lines", "float" }) do
    if style[target] then
      if style[target].format and style[target].format == "dynamic" then
        style[target].format = opts.formats[opts.current.format]
      end
      if style[target].severity and style[target].severity == "dynamic" then
        style[target].severity = opts.severities[opts.current.severity]
      end
    end
  end
  vim.diagnostic.config(style)
end

return M
