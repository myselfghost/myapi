
local _M = { _clsName = 'mysqlConn' }
local mt = { __index = _M }
 
local mysql = require ("resty.mysql")
local error = error
local ipairs = ipairs
local pairs = pairs
local require = require
local tonumber = tonumber
local function tapd(t, v) t[#t+1] = v end
 
local timeout_subsequent_ops = 5000 -- 5 sec
local max_idle_timeout = 10000 -- 10 sec
local keeplive_pool = 300
local max_packet_size = 1024 * 1024 -- 1MB
local STATE_CONNECTED = 1
local STATE_COMMAND_SENT = 2

local dbinfo = require ("common.db")
local options = dbinfo["main"]

local function mysql_connect(options)
 
    local db, err = mysql:new()
    if not db then error("failed to instantiate mysql: " .. err) end

    db:set_timeout(timeout_subsequent_ops)
 
    local db_options = {
        host = options.host,
        port = options.port,
        database = options.database,
        user = options.user,
        password = options.password,
        max_packet_size = max_packet_size
    }
    local ok, err, errno, sqlstate = db:connect(db_options)
    if not ok then error("failed to connect to mysql: " .. err) end
    return db
end

local function mysql_keepalive(db, options)
    local ok, err = db:set_keepalive(max_idle_timeout, keeplive_pool)
    if not ok then error("failed to set mysql keepalive: ", err) end
end
 
local function db_execute(options, db, sql, rowAsList)

    local res, err, errno, sqlstate = db:query(sql, _, rowAsList)
    if not res then
		if not errno then errno = '' end
		if not sqlstate then sqlstate = '' end
		error("bad mysql result: " .. err .. ": " .. errno .. " " .. sqlstate)
	end

    return res
end

function _M:new()
    local this = {
    	_clsName = _M._clsName,
		options = options, 
		_inTrans = false
    }
 
	local db = mysql_connect(options)
	if not db then
		error('connect db failed')
	else
		this.db = db
	end

    setmetatable(this, mt)

    return this
end
    
function _M:checkDb()
	local db = self.db
	local options = self.options
	if db then
		if db.state ~= STATE_CONNECTED then
			db = mysql_connect(options)
			self.db = db
		end
	else
		db = mysql_connect(options)
		self.db = db
	end
end

function _M:execute(sql, rowAsList)

	self:checkDb()
	local options = self.options
	local db = self.db
	local res = db_execute(options, db, sql, rowAsList)
	if not self._inTrans then
		mysql_keepalive(db, options)
		self.db = nil
	end

	return res
end

function _M:beginTrans()
	if self._inTrans then
		error('already in trans')
	else
		self._inTrans = true
		local res = self:execute('START TRANSACTION;')
		if res then 
			return true
		else
			self._inTrans = false
			return false
		end
	end
end

function _M:commitTrans()
	if not self._inTrans then
		error('not in a trans')
	else
		local res = self:execute('COMMIT;')
		self._inTrans = false
		return res and true or false
	end
end

function _M:rollback()
	local res = self:execute('ROLLBACK;')
	self._inTrans = false
	return res and true or false
end
 
return _M
