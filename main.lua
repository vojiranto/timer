#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Name:        SCTR - Simple Console Time Registrator                       --
-- Version:     0.2.4.2                                                      --
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

local help = function (cmd)
    if cmd == "show" then
        io.write(localization.helpShow)
    else    
        io.write(localization.help)
end end

local tableIndex      = Index()
local tableOfWorkTime = ActiveTableOfWorkTime(tableIndex)
local show            = Show(tableIndex)
local timer           = Timer(tableOfWorkTime)


local exit = function ()
    timer.stop()
    tableOfWorkTime.print()
    os.exit()
end


local userCommand = comands {
    [{"help",    "h"}]  = help,
    [{"exit",    "e"}]  = exit,
    [{"local",   "l"}]  = setLocalization,
    [{"show",    "sh"}] = show.table,
    [{"work",    "wt"}] = tableOfWorkTime.print,
    [{"restart", "r"}]  = timer.restart,
    start               = timer.start,
    stop                = timer.stop,
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
