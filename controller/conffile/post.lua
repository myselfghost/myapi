local Func = require ("common.functions")
local Val = require ("library.validation")
local Sql = require ("model.conffile.post")
local Json = require ("cjson")

--[[local Args = Func.get_post_args()
if not Args then
	ngx.say("404")
	return
end
--]]
local Mykey = {"a1","a2","b1"}
local Isallkey = Func.is_all_args(Args,Mykey)
if not Isallkey  then
	ngx.say("not all key")
	return 
end

local valid, e = Val.number:between(0, 9)((tonumber(Args["a1"])
if not valid then
	ngx.say("a1 is not allowed")
	return
end

local valid, e = Val.email(Args["a2"])
if not valid then
	ngx.say("a1 is not allowed")
	return
end

local res = Sql.add(Args["a1"],Args["a2"],Args["b2"])
ngx.say(Json.encode(res))

ngx.say("conffile post ok")