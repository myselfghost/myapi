local _M = {}
local mysql = require("library.y-mysql")
local dbinfo = require ("common.db")
local options = dbinfo["main"]

function _M.add(a1,a2,b1)
	mysql:new(options)
	local qer = "INSERT INTO conffile (a1,a2,b1) VALUES ("..a1..","..a2..","..b1..")"
	local res = mysql:execute(qer)
	return res
end
return _M