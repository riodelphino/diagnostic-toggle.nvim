-- HINT
local result = 100

-- INFO
-- Add code for INFO here

-- WARN
vim.fn.fnamemodify('/path/to/file')

-- WARN + WARN
local a = a; local b = b
print(a, b)

-- WARN + HINT
local c = c; local c = c
print(c)

-- ERROR
local x
if x != "text" then
  print(x)
end

-- WARN + ERROR
local y
if y != "text" then end

-- ERROR + ERROR
if y != "text" and y = y + 1 then
  print(y)
end
