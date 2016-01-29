--init something
    local AppDir = ngx.var.appdir
    package.path = AppDir.."/?.lua;;"
    Constent = require ("common.constent")
    local Func = require ("common.functions")
-- [[if location = / --]]
    if not Func.is_in_table(ngx.var.path,Constent["apis"])  then
       ngx.say("welcome to myapi")
       return
    end

--let's work
    ngx.req.read_body()
    local Methmod = ngx.req.get_method()
    if  Methmod == "GET" then
    require ("controller."..ngx.var.path.."/get")
    end
    if  Methmod == "POST" then
    require ("controller."..ngx.var.path.."/post")
    end
