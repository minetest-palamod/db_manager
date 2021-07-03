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

function DbRef:get_row(q)
	q = q .. " LIMIT 1;"
	for row in self.db:nrows(q) do
		return row
	end
end

setmetatable(DbRef, {__call = function(self, ...)
	return self.new(...)
end})

metatable.__index = DbRef