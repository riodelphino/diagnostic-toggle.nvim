local util = require("diagnostic-toggle.util")
local state = require("diagnostic-toggle.state")

local M = {}

---Toggle or set style
---@param style_name string?
function M.toggle_style(style_name)
  local opts = require("diagnostic-toggle.config").options
  if not style_name then
    local toggle_map = opts.sequences.styles
    style_name = toggle_map[state.current.style]
  end
  state.current.style = style_name
  M.apply_diagnostic_config()
  util.notify_on_toggle("style", style_name)
end

---Toggle or set format
---@param format_name string?
function M.toggle_format(format_name)
  local opts = require("diagnostic-toggle.config").options
  if not format_name then
    local toggle_map = opts.sequences.formats
    format_name = toggle_map[state.current.format]
  end
  state.current.format = format_name
  M.apply_diagnostic_config()
  util.notify_on_toggle("format", format_name)
end

---Toggle or set severity
---@param severity_name string?
function M.toggle_severity(severity_name)
  local opts = require("diagnostic-toggle.config").options
  if not severity_name then
    local toggle_map = opts.sequences.severities
    severity_name = toggle_map[state.current.severity]
  end
  state.current.severity = severity_name
  M.apply_diagnostic_config()
  util.notify_on_toggle("severity", severity_name)
end

---Apply all current style/format/severity to diagnostic config
function M.apply_diagnostic_config()
  local opts = require("diagnostic-toggle.config").options
  local style = vim.deepcopy(opts.styles[state.current.style])
  -- Replace format and severity dynamically
  for _, target in ipairs({ "virtual_text", "virtual_lines", "float" }) do
    if style[target] then
      if style[target].format and style[target].format == "auto" then
        style[target].format = opts.formats[state.current.format]
      end
      if style[target].severity and style[target].severity == "auto" then
        style[target].severity = opts.severities[state.current.severity]
      end
    end
  end
  vim.diagnostic.config(style)
end

return M
