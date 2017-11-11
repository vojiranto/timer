#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Name:        SCTR - Simple Console Time Registrator                       --
-- Version:     0.2.4.1                                                      --
-- Author:      D.A. Pavlyuk                                                 --
-- License:     GPL                                                          --
-- Description: The program for the account of working hours.                --
-------------------------------------------------------------------------------
local files = {
    "functions",       "file",                  "localization", "index",
    "tableOfWorkTime", "activeTableOfWorkTime", "timer",        "show"
}

for _, fileName in pairs(files) do
    dofile(fileName .. ".lua")
end

local help = function ()
    io.write(localization.help)
end

local tableIndex      = Index()
local tableOfWorkTime = ActiveTableOfWorkTime(tableIndex)
local show            = Show(tableIndex)
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
    show      = show.table,
    work      = tableOfWorkTime.print,
    start     = timer.start,
    restart   = timer.restart,
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
