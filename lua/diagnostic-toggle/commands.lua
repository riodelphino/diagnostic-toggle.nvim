local core = require("diagnostic-toggle.core")
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
    else
      vim.notify("Usage: DiagnosticToggle {style|format|severity} [value]", vim.log.levels.ERROR)
    end
  end, {
    nargs = "+",
    complete = function(arg_lead, cmdline, cursor_pos)
      local args = vim.split(cmdline, "%s+", { trimempty = true })

      if #args <= 1 then
        vim.notify(cmdline, vim.log.levels.INFO)
        return { "style", "format", "severity" }
      end

      if #args == 2 then
        vim.notify(cmdline, vim.log.levels.INFO)
        local subcommand = args[2]
        local opts = config.options

        if subcommand == "style" then
          return vim.tbl_keys(opts.styles)
        elseif subcommand == "format" then
          return vim.tbl_keys(opts.formats)
        elseif subcommand == "severity" then
          return vim.tbl_keys(opts.severities)
        end
      end

      return {}
    end,
    desc = "Toggle or set diagnostic display settings",
  })
end

return M
