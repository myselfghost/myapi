local PrivateKey = "hadals.com"
ngx.req.read_body()
local args, err = ngx.req.get_post_args()
if not args then
    ngx.say("failed to get post args: ", err)
    return
end
-- chech Identify
if PrivateKey ~= args["key"] then
    ngx.say("you should not be there !")
    return
end
