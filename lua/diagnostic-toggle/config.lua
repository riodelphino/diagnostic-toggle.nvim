local core = require("diagnostic-toggle.core")

local M = {}

---Get current style dynamically
function M.get_style()
  return function()
    local current_style = M.options.current.style
    return M.options.styles[current_style]
  end
end

---Get current format dynamically
function M.get_format()
  return function(diagnostic)
    local current_format = M.options.current.format
    return M.options.formats[current_format](diagnostic)
  end
end

---Get current severity dynamically
function M.get_severity()
  return function()
    local current_severity = M.options.current.severity
    return M.options.severities[current_severity]
  end
end

local defaults = {
  defaults = {
    style = "both",
    format = "short",
    severity = "all",
  },
  toggle = {
    styles = { both = "text", text = "lines", lines = "both" },
    formats = { short = "long", long = "short" },
    severities = { all = "hint", hint = "info", info = "warn", warn = "error", error = "all" },
  },
  styles = {
    both = {
      virtual_text = {
        format = M.get_format(),
        severity = { max = vim.diagnostic.severity.WARN },
      },
      virtual_lines = {
        format = M.get_format(),
        severity = { min = vim.diagnostic.severity.ERROR },
      },
      float = false,
    },
    lines = {
      virtual_text = false,
      virtual_lines = {
        format = M.get_format(),
      },
      float = false,
    },
    text = {
      virtual_text = {
        format = M.get_format(),
      },
      virtual_lines = false,
      float = false,
    },
  },
  formats = {
    short = function(diagnostic)
      return string.format("%s", diagnostic.message)
    end,
    long = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
  severities = {
    all = { min = { vim.diagnostic.severity.HINT } },
    info = { min = { vim.diagnostic.severity.INFO } },
    warn = { min = { vim.diagnostic.severity.WARN } },
    error = { min = { vim.diagnostic.severity.ERROR } },
  },
}

M.options = defaults

return M
