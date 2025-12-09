-- ╭───────────────────────────────────────────────────────────────╮
-- │                     Diagnostic Test Code                      │
-- ╰───────────────────────────────────────────────────────────────╯
-- Usage: `:source %` to show diagnostic tests on this buffer

local test

-- Single diagnostic
test = "HINT"
test = "INFO"
test = "WARN"
test = "ERROR"

-- Double diagnostics
test = "HINT + HINT"
test = "INFO + INFO"
test = "WARN + WARN"
test = "ERROR + ERROR"

-- Mixed 2 diagnostics
test = "HINT + INFO"
test = "INFO + WARN"
test = "WARN + ERROR"

-- Mixed 3 ~ 4 diagnostics
test = "INFO + WARN + ERROR"
test = "HINT + INFO" .. "WARN + ERROR"
_ = test

---@type {lnum:integer, col:integer, end_col:integer, severity:string, message:string, code:string}[]
local diagnostic_items = {
  -- Single
  { 8, 0, 4, "HINT", "Test HINT", "test-hint" },
  { 9, 0, 4, "INFO", "Test INFO", "test-info" },
  { 10, 0, 4, "WARN", "Test WARN", "test-warn" },
  { 11, 0, 4, "ERROR", "Test ERROR", "test-error" },
  -- Double
  { 14, 0, 4, "HINT", "Test HINT 1", "test-hint" },
  { 14, 7, 20, "HINT", "Test HINT 2", "test-hint" },
  { 15, 0, 4, "INFO", "Test INFO 1", "test-info" },
  { 15, 7, 20, "INFO", "Test INFO 2", "test-info" },
  { 16, 0, 4, "WARN", "Test WARN 1", "test-warn" },
  { 16, 7, 20, "WARN", "Test WARN 2", "test-warn" },
  { 17, 0, 4, "ERROR", "Test ERROR 1", "test-error" },
  { 17, 7, 23, "ERROR", "Test ERROR 2", "test-error" },
  -- Mixed 2
  { 20, 0, 4, "HINT", "Test HINT", "test-hint" },
  { 20, 7, 20, "INFO", "Test INFO", "test-info" },
  { 21, 0, 4, "INFO", "Test INFO", "test-info" },
  { 21, 7, 20, "WARN", "Test WARN", "test-warn" },
  { 22, 0, 4, "WARN", "Test WARN", "test-warn" },
  { 22, 7, 20, "ERROR", "Test ERROR", "test-error" },
  -- Mixed 3
  { 25, 0, 4, "INFO", "Test INFO", "test-info" },
  { 25, 5, 6, "WARN", "Test WARN", "test-warn" },
  { 25, 7, 28, "ERROR", "Test ERROR", "test-error" },
  -- Mixed 4
  { 26, 0, 4, "HINT", "Test HINT", "test-hint" },
  { 26, 5, 6, "INFO", "Test INFO", "test-info" },
  { 26, 7, 20, "WARN", "Test WARN", "test-warn" },
  { 26, 24, 39, "ERROR", "Test ERROR", "test-error" },
}

local ns = vim.api.nvim_create_namespace("diagnostic-toggle-test")
local source = "sample_lsp"
local diagnostics = {}

for _, d in ipairs(diagnostic_items) do
  local lnum, col, end_col, severity, message, code = unpack(d)
  severities = {
    HINT = vim.diagnostic.severity.HINT,
    INFO = vim.diagnostic.severity.INFO,
    WARN = vim.diagnostic.severity.WARN,
    ERROR = vim.diagnostic.severity.ERROR,
  }
  table.insert(diagnostics, {
    lnum = lnum,
    col = col,
    end_col = end_col,
    severity = severities[severity],
    message = message,
    source = source,
    code = code,
  })
end

vim.diagnostic.set(ns, 0, diagnostics)
