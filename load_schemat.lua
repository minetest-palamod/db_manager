local shemats = {}

function db_manager.get_schemat(name)
	local modname, shem = string.match(name, "(.-):(.*)")
	assert(modname)
	assert(shem)
	if shemats[name] then
		return shemats[name]
	end
	shemats[name..":"..shem] = io.open(minetest.get_modpath(modname).."/sql/"..shem, "r"):read("*all")
	return shemats[name]
end