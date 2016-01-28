--init something
    local AppDir = ngx.var.appdir
    package.path = AppDir.."/common/?.lua;"AppDir.."/lib/?.lua;"..AppDir.."/controller/?.lua;;"
    Constent = require ("constent")
    local Func = require ("functions")
-- [[if location = / --]]
    if not Func.is_in_table(ngx.var.path,Constent["apis"])  then
       ngx.say("welcome to myapi")
       return
    end

--let's work
    ngx.req.read_body()
    local Methmod = ngx.req.get_method()
    if  Methmod == "GET" then
    require (ngx.var.path.."/get")
    end
    if  Methmod == "POST" then
    require (ngx.var.path.."/post")
    end
