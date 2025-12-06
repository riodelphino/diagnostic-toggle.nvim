# diagnostic-toggle.nvim

A Neovim plugin that lets you switch between pre-configured diagnostic styles on the fly.

I normally use a mixed layout with both `virtual_text` and `virtual_lines`, but sometimes I want to view only `virtual_lines` to read all messages clearly. Other times I need extra details like error IDs for searching online.


## Features

You can toggle these aspects independently:

- Style — Presets combining virtual_text|virtual_lines|float diagnostics
- Format — How diagnostic messages are displayed
- Severity — Which severities are shown


## Config

### Minimum Setup

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
  -- Other config here
  ...
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
  toggle = {
    -- Toggle sequence maps. Example: when current is 'both', next will be 'text'
    styles = { both = "text", text = "lines", lines = "both" },  -- both -> text -> lines -> both
    formats = { short = "long", long = "short" }, -- short <-> long
    severities = { all = "hint", hint = "info", info = "warn", warn = "error", error = "all" }, -- all -> info -> warn -> error -> all
  },
  styles = { -- `style` presets
    both = { -- Mixed style: Shows virtual_text for HINT/INFO/WARN. Shows virtual_lines for ERROR.
      virtual_text = {
        format = M.get_format(),
        severity = { max = vim.diagnostic.severity.WARN },
      },
      virtual_lines = {
        format = M.get_format(),
        severity = { min = vim.diagnostic.severity.ERROR },
      },
      float = false,
    },
    lines = { -- A style with virtual_lines only
      virtual_text = false,
      virtual_lines = {
        format = M.get_format(),
      },
      float = false,
    },
    text = { -- A style with virtual_text only
      virtual_text = {
        format = M.get_format(),
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
    all = { min = { vim.diagnostic.severity.HINT } }, -- A severity preset shows all
    info = { min = { vim.diagnostic.severity.INFO } }, -- A severity preset shows INFO, WARN, ERROR
    warn = { min = { vim.diagnostic.severity.WARN } }, -- A severity preset shows WARN, ERROR
    error = { min = { vim.diagnostic.severity.ERROR } }, -- A severity preset shows only ERROR
    -- Add your severity presets here
  },
}
```
> [!Warning]
> `M.get_format()` should be replaced with `require('diagnostic-toggle.config').get_format()` in your config.
> See below section.


### Dynamic Toggling for format and severity

To use dynamic toggling for `format` and `severity` in your config, use following two functions:
```lua
require('diagnostic-toggle.config').get_format()
require('diagnostic-toggle.config').get_severity()
```

(e.g.)
```lua
local config = require('diagnostic-toggle.config')
require('diagnostic-toggle').setup({
  styles = {
    your_style = {
      virtual_text = {
        format = config.get_format(), -- Set format dynamically
        severity = config.get_severity(), -- Set severity dynamically
      },
      virtual_lines = {
        format = config.get_format(),
        severity = config.get_severity(),
      },
      float = false,
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
      virtual_text = { format = M.get_format() },
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

