-- hint
local result = 100

-- warn
vim.fn.fnamemodify('/path/to/file')

-- warn x 2
local a = a; local b = b
print(a, b)

-- warn + hint
local c = c; local c = c
print(c)

-- error
local x
if x != "text" then
  print(x)
end

-- warn + error
local y
if y != "text" then end

-- error x 2
if y != "text" and y = y + 1 then
  print(y)
end
