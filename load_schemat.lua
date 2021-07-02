local shemats = {}

for _,name in pairs(minetest.get_modnames()) do
	local modpath = minetest.get_modpath(name)
	for _,filename in pairs(minetest.get_dir_list(modpath.."/sql/", false)) do
		shemats[name..":"..filename] = io.open(modpath.."/sql/"..filename, "r"):read()
	end
end

function db_manager.get_schemat(name)
	local modname, shem = string.match(name, "(.-):(.*)")
	assert(modname)
	assert(shem)
	return shemats[name]
end