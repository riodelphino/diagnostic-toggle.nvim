local M = {}

local defaults = {
  defaults = {
    style = "both",
    format = "short",
    severity = "all",
  },
  sequences = {
    styles = { both = "text", text = "lines", lines = "both" },
    formats = { short = "long", long = "short" },
    severities = { all = "info~", ["info~"] = "warn~", ["warn~"] = "error~", ["error~"] = "all" },
  },
  notify = {
    enabled = true,
    on_setup = false,
    on_toggle = {
      style = true,
      format = true,
      severity = true,
    },
  },
  styles = {
    both = {
      virtual_text = {
        format = "auto",
        severity = { max = vim.diagnostic.severity.WARN },
      },
      virtual_lines = {
        format = "auto",
        severity = { min = vim.diagnostic.severity.ERROR },
      },
      float = false,
    },
    lines = {
      virtual_text = false,
      virtual_lines = {
        format = "auto",
        severity = "auto",
      },
      float = false,
    },
    text = {
      virtual_text = {
        format = "auto",
        severity = "auto",
      },
      virtual_lines = false,
      float = false,
    },
  },
  formats = {
    short = function(diagnostic) return string.format("%s", diagnostic.message) end,
    long = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
  severities = {
    all = { min = vim.diagnostic.severity.HINT },
    ["info~"] = { min = vim.diagnostic.severity.INFO },
    ["warn~"] = { min = vim.diagnostic.severity.WARN },
    ["error~"] = { min = vim.diagnostic.severity.ERROR },
  },
}

M.options = defaults

return M
