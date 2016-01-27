local _M = {}
function _M.IsInTable(value, tbl)
for k,v in ipairs(tbl) do
  if v == value then
  return true
  end
end
return false
end
return _M
