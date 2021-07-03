local db = db_manager.database("db1:test", db_manager.get_schemat("db1:test.sql"))

db:exec("INSERT INTO money VALUES ('playername', 500)")

local out = db:get_rows("SELECT * FROM money")

minetest.log("action", "[db1]----------------------------------------")
minetest.log("action", dump(out))
minetest.log("action", "[db1]----------------------------------------")
