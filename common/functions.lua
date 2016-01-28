local _M = {}
function _M.is_in_table(value, tbl)
for k,v in pairs(tbl) do
  if v == value then
    return true
  end
end
return false
end
function _M.is_key(key, tbl)
  for k,v in pairs(tbl) do
    if k == key then
      return true
    end
  end
return false
end
function _M.get_post_args()
  ngx.req.read_body()
  local args, err = ngx.req.get_post_args()
  if not args then
    ngx.log(ngx.ERR,"failed to find post args ",err)
    return false
  end
  return args
end
function _M.is_all_args(args,keys)
  for k2,v2 in pairs(keys) do
    if not _M.is_key(v2,args) then
      return false
    end
  end
  return true
end
return _M
