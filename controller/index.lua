--init something
    myappdir = "/usr/local/openresty/myapi"
    package.path = myappdir..'/common/?.lua;'..myappdir..'/controller/?.lua'
    constent = require ("constent")
    local func = require ("functions")
-- [[if location = / --]]
    if not func.IsInTable(ngx.var.path,constent["apis"])  then
       ngx.say("welcome")
       return
    end

--let's work
    ngx.req.read_body()
    local Methmod = ngx.req.get_method()
    if  Methmod == "GET" then
    require (ngx.var.path.."/get")
    end
    if  Methmod == "post" then
    require (ngx.var.path.."/post")
    end
