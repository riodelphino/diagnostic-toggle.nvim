local util = require("diagnostic-toggle.util")
local state = require("diagnostic-toggle.state")

local M = {}

---Toggle or set style
---@param style_name string?
function M.toggle_style(style_name)
  local opts = require("diagnostic-toggle.config").options
  if not style_name then
    local toggle_map = opts.sequences.style
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
    local toggle_map = opts.sequences.format
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
    local toggle_map = opts.sequences.severity
    severity_name = toggle_map[state.current.severity]
  end
  state.current.severity = severity_name
  M.apply_diagnostic_config()
  util.notify_on_toggle("severity", severity_name)
end

---Toggle or set current_line
---@param current_line_name string?
function M.toggle_current_line(current_line_name)
  local opts = require("diagnostic-toggle.config").options
  if not current_line_name then
    local toggle_map = opts.sequences.current_line
    current_line_name = toggle_map[state.current.current_line]
  end
  state.current.current_line = current_line_name
  M.apply_diagnostic_config()
  util.notify_on_toggle("current_line", current_line_name)
end

---Apply all current style/format/severity to diagnostic config
function M.apply_diagnostic_config()
  local opts = require("diagnostic-toggle.config").options
  local presets = opts.presets
  local style = vim.deepcopy(presets.styles[state.current.style])
  -- Replace format and severity dynamically
  for _, target in ipairs({ "virtual_text", "virtual_lines", "float" }) do
    if style[target] then
      if style[target].format and style[target].format == "auto" then
        style[target].format = presets.formats[state.current.format]
      end
      if style[target].severity and style[target].severity == "auto" then
        style[target].severity = presets.severities[state.current.severity]
      end
      if style[target].current_line and style[target].current_line == "auto" then
        style[target].current_line = presets.current_lines[state.current.current_line]
      end
    end
  end
  vim.diagnostic.config(style)
end

return M
