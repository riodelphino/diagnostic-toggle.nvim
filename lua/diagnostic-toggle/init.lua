local config = require("diagnostic-toggle.config")
local core = require("diagnostic-toggle.core")
local state = require("diagnostic-toggle.state")

local M = {}

---@param opts table?
function M.setup(opts)
  state.is_setup = true

  config.options = vim.tbl_deep_extend("force", config.options, opts)

  -- Set style/format/severity with defaults
  -- state.current = {}
  local defaults = config.options.defaults
  core.toggle_style(defaults.style)
  core.toggle_format(defaults.format)
  core.toggle_severity(defaults.severity)

  require("diagnostic-toggle.commands").add_commands()

  state.is_setup = false
end

return M
