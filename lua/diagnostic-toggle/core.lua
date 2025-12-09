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
  local ok = M.apply_diagnostic_config()
  if ok then util.notify_on_toggle("style", style_name) end
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
  local ok = M.apply_diagnostic_config()
  if ok then util.notify_on_toggle("format", format_name) end
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
  local ok = M.apply_diagnostic_config()
  if ok then util.notify_on_toggle("severity", severity_name) end
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
  local ok = M.apply_diagnostic_config()
  if ok then util.notify_on_toggle("current_line", current_line_name) end
end

---Reset to defaults
function M.reset()
  local opts = require("diagnostic-toggle.config").options
  state.current = vim.deepcopy(opts.defaults)
  local ok = M.apply_diagnostic_config()
  if ok then
    if opts.notify.on_reset then util.notify("Reset to defaults", "INFO") end
  end
end

---Apply all current style/format/severity to diagnostic config
---@return boolean? ok
function M.apply_diagnostic_config()
  local opts = require("diagnostic-toggle.config").options
  local presets = opts.presets

  local new_style = vim.deepcopy(presets.styles[state.current.style])
  local new_format = presets.formats[state.current.format]
  local new_severity = presets.severities[state.current.severity]
  local new_current_line = presets.current_lines[state.current.current_line]

  if new_style == nil then
    local msg = string.format("style '%s' not found.", state.current.style)
    util.notify(msg, "ERROR")
    return false
  end
  if new_format == nil then
    local msg = string.format("format '%s' not found.", state.current.format)
    util.notify(msg, "ERROR")
    return false
  end
  if new_severity == nil then
    local msg = string.format("severity '%s' not found.", state.current.severity)
    util.notify(msg, "ERROR")
    return false
  end
  if new_current_line == nil then
    local msg = string.format("current_line '%s' not found.", state.current.current_line)
    util.notify(msg, "ERROR")
    return false
  end

  -- Evaluate functions
  if type(new_style) == "function" then new_style = new_style() end
  if type(new_severity) == "function" then new_severity = new_severity() end
  if type(new_current_line) == "function" then new_current_line = new_current_line() end
  -- Should not evaluate `format` field, because it requires function type itself.

  -- Replace format and severity dynamically
  for _, target in ipairs({ "virtual_text", "virtual_lines", "float" }) do
    if new_style[target] then
      if new_style[target].format and new_style[target].format == "auto" then new_style[target].format = new_format end
      if new_style[target].severity and new_style[target].severity == "auto" then
        new_style[target].severity = new_severity
      end
      if new_style[target].current_line and new_style[target].current_line == "auto" then
        new_style[target].current_line = new_current_line
      end
    end
  end
  vim.diagnostic.config(new_style)
  return true
end

return M
