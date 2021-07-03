# Database Manager

[![ContentDB](https://content.minetest.net/packages/AFCM/db_manager/shields/title/)](https://content.minetest.net/packages/AFCM/db_manager/)
[![ContentDB](https://content.minetest.net/packages/AFCM/db_manager/shields/downloads/)](https://content.minetest.net/packages/AFCM/db_manager/)

This project is a mod adding an API to manage sqlite3 databases to the free voxel game engine [Minetest](https://www.minetest.net/).

## Requirements

In order to run and use this mod, you will need to:

### Install sqlite3

Folow the install guide for your system on the [official website](https://sqlite.org)

On Ubuntu you can just install it from apt:
```
sudo apt install sqlite3
```

### Install lsqlite3

[lsqlite3](http://lua.sqlite.org) is a sqlite wrapper for lua.

You should install it using [luarocks](https://luarocks.org/modules/dougcurrie/lsqlite3).

### Add this mod to secure.trusted_mods

In order to load the `lsqlite3` library, this mod needs to access an insecure environment.

Add `db_manager` to `secure.trusted_mods` setting in your `minetest.conf`

## API

This mod aims to remove the pain of working with databases.
Mods can create databases without accessing insecure environment or messing with other mods databases and manage sql schemats freely.

### `db_manager.database(name, schemat)`

This function allow a mod to create or open a database.

* name: should be in the form "modname:database_name"
* schemat (optional): a sql schemat (string) to apply to the database

Returns a `DbRef`

### `db_manager.get_schemat(name)`

This function can get any sql shemat from any mod as a string.

* name: in the form "modname:filename"

The function will search the file in the `sql` directory of the path of the modname and return it as a string.

### `DbRef`

#### `DbRef:new(name, db)`

Create a new DbRef object with:

* name: the name of the database
* db: the name of a db object (optained by calling `sqlite3.open()`)

This function is for internal use.

#### `DbRef:exec(query)`

This function execute a query and doesn't return anything.
If `lsqlite3` returns an error, a error will be shown in log.

#### `DbRef:get_rows(query)`

This function execute query and returns a lua table.