local _M = {}
local mt = {__index = _M}
local mysql = require("library.y-mysql")

function _M.add(a1,a2,b1)
	local db = mysql:new()
	local qer = "INSERT INTO conffile (a1,a2,b1) VALUES ("..a1..","..a2..","..b1..")"
	local res = db:execute(qer)
	return res
end
setmetatable(_M,mt)
return _M