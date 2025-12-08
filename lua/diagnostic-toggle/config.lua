local M = {}

local defaults = {
  defaults = {
    style = "text_and_lines",
    format = "short",
    severity = "all",
    current_line = "false",
  },
  sequences = {
    style = { text_and_lines = "only_text", only_text = "only_lines", only_lines = "text_and_lines" },
    format = { short = "long", long = "short" },
    severity = { all = "info~", ["info~"] = "warn~", ["warn~"] = "error~", ["error~"] = "all" },
    current_line = { ["false"] = "true", ["true"] = "false" },
  },
  notify = {
    enabled = true,
    on_setup = false,
    on_toggle = {
      style = true,
      format = true,
      severity = true,
      current_line = true,
    },
    on_reset = true,
  },
  presets = {
    styles = {
      text_and_lines = {
        virtual_text = {
          format = "auto",
          severity = { max = vim.diagnostic.severity.WARN },
          current_line = "auto",
        },
        virtual_lines = {
          format = "auto",
          severity = { min = vim.diagnostic.severity.ERROR },
          current_line = "auto",
        },
        float = false,
      },
      only_lines = {
        virtual_text = false,
        virtual_lines = {
          format = "auto",
          severity = "auto",
          current_line = "auto",
        },
        float = false,
      },
      only_text = {
        virtual_text = {
          format = "auto",
          severity = "auto",
          current_line = "auto",
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
    current_lines = {
      ["true"] = true,
      ["false"] = false,
    },
  },
}

M.options = defaults

return M
