#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Name:        SCTR - Simple Console Time Registrator                       --
-- Version:     0.2.3.2                                                      --
-- Author:      D.A. Pavlyuk                                                 --
-- License:     GPL                                                          --
-- Description: The program for the account of working hours.                --
-------------------------------------------------------------------------------
dofile("functions.lua")
dofile("file.lua")
dofile("localization.lua")
dofile("index.lua")
dofile("tableOfWorkTime.lua")
dofile("activeTableOfWorkTime.lua")
dofile("timer.lua")

local help = function ()
    io.write(localization.help)
end

local tableIndex      = Index()
local tableOfWorkTime = ActiveTableOfWorkTime(tableIndex)
local timer           = Timer(tableOfWorkTime)

local exit = function ()
    timer.stop()
    tableOfWorkTime.print()
    os.exit()
end


local showSumTable = function () 
    local sumTable, tmpTable = TableOfWorkTime(), TableOfWorkTime()
    for _, tableName in pairs(tableIndex.getIndex()) do   
        tmpTable.load("tables/".. tableName ..".lua")
        for key, val in pairs(tmpTable.table()) do
            sumTable.addIn(key, val)
    end end
    sumTable.print()
end


local showTable = function (tableName) 
    if tableName == "sum table" then
        showSumTable()
        return    
    end

    local fileName = "tables/".. tableName ..".lua"
    if File(fileName).exist() then
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
