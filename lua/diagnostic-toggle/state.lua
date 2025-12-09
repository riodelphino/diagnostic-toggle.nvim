local M = {}

---@class diagnostic-toggle.State
M = {
  is_setup = false,
  is_toggle = false, -- Not used
  current = {
    style = nil,
    format = nil,
    severity = nil,
    current_line = nil,
  },
}

return M
