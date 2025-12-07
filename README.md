# diagnostic-toggle.nvim

A Neovim plugin that lets you switch between pre-configured diagnostic styles on the fly.

I normally use a mixed layout with both `virtual_text` and `virtual_lines`, but sometimes I want to view only `virtual_lines` to read all messages clearly. Other times I need extra details like error IDs for searching online.

If you're usin the built-in diagnostics, this might be a good option.


## Features

You can toggle these aspects independently:

- Style — Presets combining virtual_text|virtual_lines|float diagnostics
- Format — How diagnostic messages are displayed
- Severity — Which severities are shown


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
    style = "both",   -- Default style name
    format = "short", -- Default format name
    severity = "all", -- Default severity name
  },
  sequences = { -- Toggle sequence maps. Example: when current is 'both', next will be 'text'
    styles = { both = "text", text = "lines", lines = "both" },  -- both -> text -> lines -> both
    formats = { short = "long", long = "short" }, -- short <-> long
    severities = { all = "info~", ["info~"] = "warn~", ["warn~"] = "error~", ["error~"] = "all" },, -- all -> info~ -> warn~ -> error~ -> all
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
  styles = { -- `style` presets
    both = { -- Mixed style: Shows virtual_text for HINT/INFO/WARN. Shows virtual_lines for ERROR.
      virtual_text = {
        format = "dynamic" -- Set "dynamic" to toggle on the fly
        severity = { max = vim.diagnostic.severity.WARN }, -- Fixed severity
      },
      virtual_lines = {
        format = "dynamic"
        severity = { min = vim.diagnostic.severity.ERROR },
      },
      float = false, -- Set false to disable
    },
    lines = { -- A style with virtual_lines only
      virtual_text = false,
      virtual_lines = {
        format = "dynamic",
        severity = "dynamic",
      },
      float = false,
    },
    text = { -- A style with virtual_text only
      virtual_text = {
        format = "dynamic",
        severity = "dynamic",
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
}
```

### Enable Toggling

Use `"dynamic"` for toggling `format` and `severity` in your config
```lua
require('diagnostic-toggle').setup({
  styles = {
    your_style = {
      virtual_text = {
        format = "dynamic", -- Allow toggling format on the fly
        severity = "dynamic", -- Allow toggling severity on the fly
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
      virtual_text = { format = "dynamic" },
      virtual_lines = false, -- Disabled
      float = false, -- Disabled
    },
  },
})
```

## Usage

Toggle between presets:
```vim
" Toggle style
:DiagnosticToggle style

" Toggle format
:DiagnosticToggle format

" Toggle severity
:DiagnosticToggle severity
```

Specify a existing preset:
```vim
" Toggle style to `lines
:DiagnosticToggle style lines

" Toggle format to `long`
:DiagnosticToggle format long

" Toggle severity to `warn`
:DiagnosticToggle severity warn
```
Completion works for sub-commands and preset names.


## API

Equivalant functions are available.

Toggle between presets:
```lua
local core = require('diagnostic-toggle.core')

-- Toggle style
core.toggle_style()

-- Toggle foramt
core.toggle_format()

-- Toggle severity
core.toggle_severity()
```

Specify a existing preset:
```lua
local core = require('diagnostic-toggle.core')

-- Toggle style to `lines`
core.toggle_style('lines')

-- Toggle foramt to `long`
core.toggle_format('long')

-- Toggle severity to `warn`
core.toggle_severity('warn')
```

## Keymaps

Recommended keymaps for lazy.nvim:
```lua
keys = {
  { 'gtt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, desc = 'Toggle Diagnostic Enabled' },
  { 'gts', ':DiagnosticToggle style<cr>', desc = 'Diagnostic toggle - style', silent = true },
  { 'gtf', ':DiagnosticToggle format<cr>', desc = 'Diagnostic toggle - format', silent = true },
  { 'gtv', ':DiagnosticToggle severity<cr>', desc = 'Diagnostic toggle - severity', silent = true },
},
```

Same keymaps with API:
```lua
keys = {
  { 'gtt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, desc = 'Toggle Diagnostic Enabled' },
  { 'gts', function() require('diagnostic-toggle.core').toggle_style() end, desc = 'Diagnostic toggle - style' },
  { 'gtf', function() require('diagnostic-toggle.core').toggle_format() end, desc = 'Diagnostic toggle - format' },
  { 'gtv', function() require('diagnostic-toggle.core').toggle_severity() end, desc = 'Diagnostic toggle - severity' },
},
```

## TODO

- [ ] Add `current_line`
- [ ] Add `:DiagnosticToggle reset` sub-command
- [ ] Add `lines` ?


## Related Projects

- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)

