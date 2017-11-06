#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Название:    SCTR - Simple Console Time Registrator                       --
-- Версия:      0.1.1.1                                                      --
-- Автор:       Д.А. Павлюк                                                  --
-- Лицензия:    GPL                                                          --
-- Описание:    Программа для учёта рабочего времени.                        --
-------------------------------------------------------------------------------
dofile("functions.lua")
dofile("tableOfWorkTime.lua")
dofile("timer.lua")


local help = function ()
    io.write[[
-------------------------------------------------------------------------------
SCTR - Simple Console Time Registrator
Список поддерживаемых команд:
    start name - начать отсчёт времени для задания name
    stop       - закончить отсчёт
    work time  - вывести потраченное время
    help       - вывести help
    exit       - выходим из программы
-------------------------------------------------------------------------------
]]
end


local tableOfWorkTime = TableOfWorkTime()
local timer           = Timer(tableOfWorkTime)


local exit = function ()
    timer.stop()
    tableOfWorkTime.print()
    os.exit()
end


local userCommand = {
    help  = help,
    exit  = exit,
    work  = tableOfWorkTime.print,
    start = timer.start,
    stop  = timer.stop,
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
