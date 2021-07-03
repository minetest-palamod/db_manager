local shemats = {}

function db_manager.get_schemat(name)
	local modname, shem = string.match(name, "(.-):(.*)")
	assert(modname)
	assert(shem)
	if shemats[name] then
		return shemats[name]
	end
	shemats[name] = io.open(minetest.get_modpath(modname).."/sql/"..shem, "r"):read("*all")
	minetest.log("error", dump(shemats[name]))
	return shemats[name]
end