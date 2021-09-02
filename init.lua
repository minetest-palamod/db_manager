minetest.log("action", "[db_manager] loading...")

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

db_manager = {}

dofile(modpath.."/database.lua")
dofile(modpath.."/load_schemat.lua")

minetest.log("action", "[db_manager] loaded succesfully")