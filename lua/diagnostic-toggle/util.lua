local state = require("diagnostic-toggle.state")

local M = {}

---@param msg string
---@param level_name string?
---@param notify_opts table?
function M.notify(msg, level_name, notify_opts)
  local opts = require("diagnostic-toggle.config").options
  if not opts.notify.enabled then return end
  if state.is_setup and not opts.notify.on_setup then return end
  level_name = level_name or "INFO"
  notify_opts = vim.tbl_deep_extend("force", { title = "diagnostic-toggle.nvim" }, notify_opts or {})
  vim.notify(msg, vim.log.levels[level_name], notify_opts)
end

---@param target "style"|"format"|"severity"|"current_line"
function M.notify_on_toggle(target, current_value)
  local opts = require("diagnostic-toggle.config").options
  if not opts.notify.on_toggle[target] then return end
  local msg = string.format("Current %s: %s", target, current_value)
  M.notify(msg, "INFO")
end

return M
