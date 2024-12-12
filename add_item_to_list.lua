--created to be launched not by the game and only to make it easier to work with the list

local repl_list = require("replace_list")
local serpent = require("serpent")
local utils = require("utils")

print("string to add:")
local path = io.read()
if #path == 0 then
    return
end

path_spl = utils.split(path)

function nested_table(table, items, ind)
    if table[items[ind]] == nil then
        new_item = ""
        if ind < #items then
            new_item = {}
        end
        table[items[ind]] = new_item
    end
    if ind < #items then
        nested_table(table[items[ind]], items, ind + 1)
    end
end

nested_table(repl_list, path_spl, 1)

io.open("replace_list.lua", "w"):write("return "..serpent.block(repl_list, {fatal = true, comment = false, indent = '    '}))