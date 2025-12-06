local config = require("diagnostic-toggle.config")
local core = require("diagnostic-toggle.core")

local M = {}

function M.setup(opts)
  config.options = vim.tbl_deep_extend("force", config.options, opts)

  -- Set current
  if not config.options.current then
    config.options.current = vim.fn.copy(config.options.defaults)
  end

  -- Setup default for style, format, severity
  local current = config.options.current
  core.toggle_style(current.style)
  core.toggle_format(current.format)
  core.toggle_severity(current.severity)

  require("diagnostic-toggle.commands").add_commands()
end

return M
