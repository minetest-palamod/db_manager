local log = minetest.log

local string = string

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

function DbRef:exec(q)
	if self.db:exec(q) ~= sql.OK then
		minetest.log("error", "[db_manager] ["..self.name.."]: lSQLite: "..self.db:errmsg())
	end
end

setmetatable(DbRef, {__call = function(self, ...)
	return self.new(...)
end})

metatable.__index = DbRef


function db_manager.database(name, schemat)
	if active_databases[name] then
		error(string.format("[db_manager] Database [%s] already existing", name))
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
	if schemat then
		db_ref:exec(schemat)
	end
	active_databases[name] = db
	return db_ref
end

--[=[
--local libpath = minetest.settings:get("mc_economy.lsqlite3_path") or ""
--package.cpath = "/usr/local/lib/lua/5.1/?.so"--..libpath

local db = sql.open(worldpath .. "/mc_economy.sqlite")

local function sql_exec(q)
	if db:exec(q) ~= sql.OK then
		minetest.log("error", "[mc_economy] lSQLite: " .. db:errmsg())
	end
end

local function sql_row(q)
	q = q .. " LIMIT 1;"
	for row in db:nrows(q) do
		return row
	end
end

sql_exec([[
	CREATE TABLE IF NOT EXISTS money(
		player TEXT PRIMARY KEY NOT NULL,
		amount INTEGER NOT NULL
);]])
]=]