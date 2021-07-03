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
