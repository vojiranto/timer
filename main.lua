#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Name:        SCTR - Simple Console Time Registrator                       --
-- Version:     0.1.3.1                                                      --
-- Author:      D.A. Pavlyuk                                                 --
-- License:     GPL                                                          --
-- Description: The program for the account of working hours.                --
-------------------------------------------------------------------------------

dofile("localization.lua")
dofile("functions.lua")
dofile("tableOfWorkTime.lua")
dofile("timer.lua")


local help = function ()
    io.write(localization.help)
end


local tableOfWorkTime = TableOfWorkTime()
local timer           = Timer(tableOfWorkTime)


local exit = function ()
    timer.stop()
    tableOfWorkTime.print()
    os.exit()
end


local userCommand = {
    help      = help,
    exit      = exit,
    ["local"] = setLocalization,
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
