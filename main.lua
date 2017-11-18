#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Name:        SCTR - Simple Console Time Registrator                       --
-- Version:     0.2.4.5                                                      --
-- Author:      D.A. Pavlyuk                                                 --
-- License:     GPL                                                          --
-- Description: The program for the account of working hours.                --
-------------------------------------------------------------------------------

function dofiles (files)
    for _, fileName in pairs(files) do
        dofile("src/".. fileName .. ".lua")
end end

new = {}
dofiles {
    "functions",
    "file",    
    "localization",
    "index",
    "tableOfWorkTime",
    "activeTableOfWorkTime",
    "timer",
    "show",
}

local function help (cmd)
    if cmd == "show" then
        io.write(localization.helpShow)
    else    
        io.write(localization.help)
end end

local objs = {}

objs.localization    = new.Localization()
objs.tableIndex      = new.Index()
objs.tableOfWorkTime = new.ActiveTableOfWorkTime(objs.tableIndex)
objs.show            = new.Show(objs.tableIndex)
objs.timer           = new.Timer(objs.tableOfWorkTime)


objs.localization.init()


local function exit ()
    objs.timer.stop()
    objs.tableOfWorkTime.print()
    os.exit()
end


local userCommand = comands {
    [{"help",    "h"}]  = help,
    [{"exit",    "e"}]  = exit,
    [{"local",   "l"}]  = objs.localization.set,
    [{"show",    "sh"}] = objs.show.table,
    [{"work",    "wt"}] = objs.tableOfWorkTime.print,
    [{"restart", "r"}]  = objs.timer.restart,
    start               = objs.timer.start,
    stop                = objs.timer.stop,
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
