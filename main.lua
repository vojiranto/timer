#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Name:        SCTR - Simple Console Time Registrator                       --
-- Version:     0.2.1.7                                                      --
-- Author:      D.A. Pavlyuk                                                 --
-- License:     GPL                                                          --
-- Description: The program for the account of working hours.                --
-------------------------------------------------------------------------------
dofile("functions.lua")
dofile("localization.lua")
dofile("tableOfWorkTime.lua")
dofile("activeTableOfWorkTime.lua")
dofile("timer.lua")

local help = function ()
    io.write(localization.help)
end

local tableOfWorkTime = ActiveTableOfWorkTime()
local timer           = Timer(tableOfWorkTime)


local exit = function ()
    timer.stop()
    tableOfWorkTime.print()
    os.exit()
end


local showTable = function (tableName) 
    local fileName = "tables/".. tableName ..".lua"
    if fileExist(fileName) then
        local table = TableOfWorkTime()
        table.load(fileName) 
        table.print()
    else
        print(localization.tableNotExist)
end end


local userCommand = {
    help      = help,
    exit      = exit,
    ["local"] = setLocalization,
    show      = showTable,
    work      = tableOfWorkTime.print,
    start     = timer.start,
    stop      = timer.stop,
}


-- main
repeat
    local string = io.read()
    local cmd, arg = string:match("(%a+) (.*)")
    cmd = cmd or string

    if userCommand[cmd] then
        userCommand[cmd](arg)
    end
until false
