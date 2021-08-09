local log = minetest.log

local string = string
local table = table

local error_level = minetest.settings:get("db_manager.error_level") or "log"

local function manage_error(name, error_msg)
	if error_level == "log" then
		--just log the error
		log("error", "[db_manager] ["..name.."]: lSQLite: "..error_msg)
	elseif error_level == "error" then
		--cause a hard crash
		error("[db_manager] ["..name.."]: lSQLite: "..error_msg)
	end
end

--create the tree where the database files will be stored
local worldpath = minetest.get_worldpath()
minetest.mkdir(worldpath.."/db_manager/")

local ie = minetest.request_insecure_environment()
if not ie then
	error("[db_manager] Cannot access insecure environment!")
end

local sql = ie.require("lsqlite3")
-- Prevent other mods from using the global sqlite3 library
if sqlite3 then
    sqlite3 = nil
end

local active_databases = {}


--DATABASE REFERENCE--
local metatable = {}

local DbRef = {}

function DbRef:new(name, db)
	return setmetatable({name = name, db = db}, metatable)
end

--Execute a query with no output
function DbRef:exec(q)
	if self.db:exec(q) ~= sql.OK then
		manage_error(self.name, self.db:errmsg())
	end
end

--Get query as table
function DbRef:get_rows(q)
	local out = {}
	for row in self.db:nrows(q) do
		table.insert(out, row)
	end
	return out
end

setmetatable(DbRef, {__call = function(self, ...)
	return self.new(...)
end})

metatable.__index = DbRef


function db_manager.database(name, schemat)
	if active_databases[name] then
		error(string.format("[db_manager] [%s]: Database already existing", name))
	end
	local mod, id = string.match(name, "(.-):(.*)")
	assert(mod)
	assert(id)
	if mod ~= minetest.get_current_modname() then
		error(string.format("[db_manager] Mod [%s] tried to access a database from another mod", mod))
	end
	minetest.mkdir(worldpath.."/db_manager/"..mod)
	local db = sql.open(worldpath.."/db_manager/"..mod.."/"..id..".sqlite")
	local db_ref = DbRef:new(name, db)
	log("action", string.format("[db_manager] [%s]: Successfully created", name))
	if schemat then
		db_ref:exec(schemat)
		log("action", string.format("[db_manager] [%s]: Executing schemat...", name))
	end
	active_databases[name] = db
	return db_ref
end