---State
---@class diagnostic-toggle.State
---@field is_setup boolean?
---@field is_toggle boolean?
---@field current {style:string?, format:string?, severity:string?, current_line:string?}

---Defaults
---@class diagnostic-toggle.Defaults
---@field style string?
---@field format string?
---@field severity string?
---@field current_line string?

---Style, Format, Severity, CurrentLine
---@alias diagnostic-toggle.Style diagnostic-toggle.DiagnosticOpts|fun(state:diagnostic-toggle.State):diagnostic-toggle.DiagnosticOpts
---@alias diagnostic-toggle.Format fun(diagnostic:vim.Diagnostic):string?|"auto"
---@alias diagnostic-toggle.Severity vim.diagnostic.SeverityFilter|fun(state:diagnostic-toggle.State):table?|"auto"
---@alias diagnostic-toggle.CurrentLine boolean|fun(state:diagnostic-toggle.State):boolean?|"auto"

---Opts
---@class diagnostic-toggle.Opts
---@field defaults diagnostic-toggle.Defaults
---@field sequences diagnostic-toggle.Opts.Sequences
---@field notify diagnostic-toggle.Opts.Notify
---@field presets diagnostic-toggle.Opts.Presets

---@class diagnostic-toggle.Opts.Sequences
---@field style table<string,string>
---@field format table<string,string>
---@field severity table<string,string>
---@field current_line table<string,string>

---@class diagnostic-toggle.Opts.Notify
---@field enabled boolean
---@field on_setup boolean
---@field on_toggle {style:boolean, format:boolean,severity:boolean,current_line:boolean}
---@field on_reset boolean

---@class diagnostic-toggle.Opts.Presets
---@field styles table<string, diagnostic-toggle.Style>
---@field formats table<string, diagnostic-toggle.Format>
---@field severities table<string, diagnostic-toggle.Severity>
---@field current_lines table<string, diagnostic-toggle.CurrentLine>

---DiagnosticOpts
---@class diagnostic-toggle.VirtualText : vim.diagnostic.Opts.VirtualText
---@field format diagnostic-toggle.Format
---@field severity diagnostic-toggle.Severity
---@field current_line diagnostic-toggle.CurrentLine

---@class diagnostic-toggle.VirtualLines : vim.diagnostic.Opts.VirtualLines
---@field format diagnostic-toggle.Format
---@field severity diagnostic-toggle.Severity
---@field current_line diagnostic-toggle.CurrentLine

---@class diagnostic-toggle.Float : vim.diagnostic.Opts.Float
---@field format diagnostic-toggle.Format
---@field severity diagnostic-toggle.Severity
---@field current_line diagnostic-toggle.CurrentLine

---@class diagnostic-toggle.DiagnosticOpts : vim.diagnostic.Opts
---@field virtual_text diagnostic-toggle.VirtualText|boolean
---@field virtual_lines diagnostic-toggle.VirtualLines|boolean
---@field float diagnostic-toggle.Float|boolean
