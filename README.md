# diagnostic-toggle.nvim

> [!Caution]
> This plugin is in early development. Breaking changes are possible.

A Neovim plugin that lets you switch between pre-configured diagnostic styles on the fly.

I normally use a mixed layout with both `virtual_text` and `virtual_lines`, but sometimes I want to view only `virtual_lines` to read all messages clearly. Other times I need extra details like error IDs for searching online.

If you're usin the built-in diagnostics, this might be a good option.


## Features

You can toggle these aspects independently:

- Style — Presets combining virtual_text|virtual_lines|float diagnostics
- Format — How diagnostic messages are displayed
- Severity — Which severities are shown

## Movies and Screenshots

[!Toggle style:](https://github.com/user-attachments/assets/76518e4e-f463-479f-af25-3d3e5eefa86f)

[!Toggle format:](https://github.com/user-attachments/assets/7e4265aa-4fa1-4111-8d50-0662810eff1c)

[!Toggle severity:](https://github.com/user-attachments/assets/ba1ff3cf-30d8-4de4-9df9-513e565218de)

## Config

### Minimal Setup

lazy.nvim:
```lua
return {
  'riodelphino/diagnostic-toggle.nvim',
  event = { 'LspAttach' },
  config = function()
    require('diagnostic-toggle').setup({})
  end,
  keys = {}, -- See `## Keymaps` section
}
```

This plugin overwrites `vim.diagnostic.config` with its own defaults on `LspAttach`.
Because of that, your existing diagnostic settings (e.g., `virtual_text`, `virtual_lines`, `float`) are ignored.
They can safely be left as false, nil, or anything else for fallback.

Diagnostic config:
```lua
---@class vim.diagnostic.Opts
vim.diagnostic.config({
  -- Followings are overwritten
  virtual_text = false,
  virtual_lines = false,
  float = false,
})
```

### Defaults

```lua
local defaults = {
  defaults = {
    style = "both", -- Default style name
    format = "short", -- Default format name
    severity = "all", -- Default severity name
    current_line = "false", -- Default current_line name
  },
  sequences = { -- Toggle sequence maps. Example: when current is 'both', next will be 'text'
    style = { both = "text", text = "lines", lines = "both" },  -- both -> text -> lines -> both
    format = { short = "long", long = "short" }, -- short <-> long
    severitie = { all = "info~", ["info~"] = "warn~", ["warn~"] = "error~", ["error~"] = "all" }, -- all -> info~ -> warn~ -> error~ -> all
    current_line = { ["false"] = "true", ["true"] = "false" }, -- false -> true -> false
  },
  notify = { -- Notify settings
    enabled = true, -- Enable notify
    on_setup = false, -- Eneable notify on setup()
    on_toggle = {
      style = true, -- Enable notify on toggling style
      format = true, -- Enable notify on toggling format
      severity = true, -- Enable notify on toggling severity
    },
  },
  presets = {
    styles = { -- `style` presets
      both = { -- Mixed style: Shows virtual_text for HINT/INFO/WARN. Shows virtual_lines for ERROR.
        virtual_text = {
          format = "auto" -- Set "auto" to toggle on the fly
          severity = { max = vim.diagnostic.severity.WARN }, -- Fixed severity is also available.
        },
        virtual_lines = {
          format = "auto"
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        float = false, -- Set false to disable
      },
      lines = { -- A style with virtual_lines only
        virtual_text = false,
        virtual_lines = {
          format = "auto",
          severity = "auto",
        },
        float = false,
      },
      text = { -- A style with virtual_text only
        virtual_text = {
          format = "auto",
          severity = "auto",
        },
        virtual_lines = false,
        float = false,
      },
      -- Add your style presets here
    },
    formats = { -- `format` presets
      short = function(diagnostic)
        return string.format("%s", diagnostic.message)
      end,
      long = function(diagnostic)
        return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
      end,
      -- Add your format presets here
    },
    severities = { -- `severity` presets
      all = { min = { vim.diagnostic.severity.HINT } }, -- Shows all
      ["info~"] = { min = { vim.diagnostic.severity.INFO } }, -- Shows INFO, WARN, ERROR
      ["warn~"] = { min = { vim.diagnostic.severity.WARN } }, -- Shows WARN, ERROR
      ["error~"] = { min = { vim.diagnostic.severity.ERROR } }, -- Shows only ERROR
      -- Add your severity presets here
    },
    current_lines = { -- `severity` presets (No need to modify)
      ["true"] = true,
      ["false"] = false,
    },
  },
}
```

### Enable Toggling

Use `"auto"` for toggling `format`, `severity`, `current_line` in your config
```lua
require('diagnostic-toggle').setup({
  styles = {
    your_style = {
      virtual_text = {
        format = "auto", -- Allow toggling format on the fly
        severity = "auto", -- Allow toggling severity on the fly
        current_line = "auto", -- Allow toggling current_line on the fly
      },
    },
  },
})
```

### Disable Specific Field

To disable specific field, use `false` instead of `nil`:
```lua
require('diagnostic-toggle').setup({
  styles = {
    your_style = {
      virtual_text = { format = "auto" },
      virtual_lines = false, -- Disabled
      float = false, -- Disabled
    },
  },
})
```

## Commands

Toggle presets:
| Command                           | Description            |
| --------------------------------- | ---------------------- |
| `:DiagnosticToggle {sub_command}` | Toggle `{sub_command}` |
| `:DiagnosticToggle style`         | Toggle `style`         |
| `:DiagnosticToggle format`        | Toggle `format`        |
| `:DiagnosticToggle severity`      | Toggle `severity`      |
| `:DiagnosticToggle current_line`  | Toggle `current_line`  |

Set a specific preset:
| Command                                              | Description                               |
| ---------------------------------------------------- | ----------------------------------------- |
| `:DiagnosticToggle style {style_name}`               | Set style to `{style_name}`               |
| `:DiagnosticToggle format {format_name}`             | Set format to `{format_name}`             |
| `:DiagnosticToggle severity {severity_name}`         | Set severity to `{severity_name}`         |
| `:DiagnosticToggle current_line {current_line_name}` | Set current_line to `{current_line_name}` |

Completion works for sub-commands and preset names.


## API

Equivalent functions are available.

Toggle presets:
```lua
local core = require('diagnostic-toggle.core')

core.toggle_style()        -- Toggle style
core.toggle_format()       -- Toggle foramt
core.toggle_severity()     -- Toggle severity
core.toggle_current_line() -- Toggle current_line
```

Set a specific preset:
```lua
local core = require('diagnostic-toggle.core')

core.toggle_style('lines')       -- Set style to `lines`
core.toggle_format('long')       -- Set foramt to `long`
core.toggle_severity('warn')     -- Set severity to `warn`
core.toggle_current_line('true') -- Set current_line to `true`
```

## Keymaps

Recommended keymaps for lazy.nvim:
```lua
keys = {
  { 'gtt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, desc = 'Toggle Diagnostic Enabled' },
  { 'gts', ':DiagnosticToggle style<cr>', desc = 'Diagnostic toggle - style', silent = true },
  { 'gtf', ':DiagnosticToggle format<cr>', desc = 'Diagnostic toggle - format', silent = true },
  { 'gtv', ':DiagnosticToggle severity<cr>', desc = 'Diagnostic toggle - severity', silent = true },
  { 'gtc', ':DiagnosticToggle current_line<cr>', desc = 'Diagnostic toggle - current_line', silent = true },
},
```

Equivalent keymaps with API:
```lua
keys = {
  { 'gtt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, desc = 'Toggle Diagnostic Enabled' },
  { 'gts', function() require('diagnostic-toggle.core').toggle_style() end, desc = 'Diagnostic toggle - style' },
  { 'gtf', function() require('diagnostic-toggle.core').toggle_format() end, desc = 'Diagnostic toggle - format' },
  { 'gtv', function() require('diagnostic-toggle.core').toggle_severity() end, desc = 'Diagnostic toggle - severity' },
  { 'gtc', function() require('diagnostic-toggle.core').toggle_current_line() end, desc = 'Diagnostic toggle - current_line' },
},
```

## TODO

- [ ] Add `:DiagnosticToggle defaults` sub-command
- [ ] Is `gt*` keymap proper?


## Related Projects

- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)

