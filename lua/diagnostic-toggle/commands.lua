local core = require("diagnostic-toggle.core")
local util = require("diagnostic-toggle.util")
local config = require("diagnostic-toggle.config")

local M = {}

---Add commands
function M.add_commands()
  -- DiagnosticToggle
  vim.api.nvim_create_user_command("DiagnosticToggle", function(opts)
    local args = opts.fargs
    local subcommand = args[1]
    local value = args[2]

    if subcommand == "style" then
      core.toggle_style(value)
    elseif subcommand == "format" then
      core.toggle_format(value)
    elseif subcommand == "severity" then
      core.toggle_severity(value)
    elseif subcommand == "current_line" then
      core.toggle_current_line(value)
    elseif subcommand == "reset" then
      core.reset()
    else
      local msg = [[
Usage:
  DiagnosticToggle {style|format|severity|current_line|reset}
  or
  DiagnosticToggle {style|format|severity|current_line} [value]
]]
      util.notify(msg, "WARN")
    end
  end, {
    nargs = "+",
    complete = function(arg_lead, cmdline, cursor_pos)
      local args = vim.split(cmdline, "%s+", { trimempty = true })

      if #args <= 1 then return { "style", "format", "severity", "current_line", "reset" } end

      if #args == 2 then
        local subcommand = args[2]
        local presets = config.options.presets

        if subcommand == "style" then
          return vim.tbl_keys(presets.styles)
        elseif subcommand == "format" then
          return vim.tbl_keys(presets.formats)
        elseif subcommand == "severity" then
          return vim.tbl_keys(presets.severities)
        elseif subcommand == "current_line" then
          return vim.tbl_keys(presets.current_lines)
        elseif subcommand == "reset" then
          return nil
        end
      end

      return {}
    end,
    desc = "Toggle or set diagnostic display settings",
  })
end

return M
