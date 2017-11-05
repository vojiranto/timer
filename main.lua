#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Название:    SCTR - Simple Console Time Registrator                       --
-- Версия:      0.1.0.0                                                      --
-- Автор:       Д.А. Павлюк                                                  --
-- Лицензия:    GPL                                                          --
-- Описание:    Программа для учёта рабочего времени.                        --
-------------------------------------------------------------------------------
dofile("functions.lua")
dofile("tableOfWorkTime.lua")
dofile("timer.lua")

tableOfWorkTime = TableOfWorkTime()
timer           = Timer(tableOfWorkTime)

local F = {}
F.help = function ()
    printLine()
    io.write[[
SCTR - Simple Console Time Registrator
Список поддерживаемых команд:
    start name - начать отсчёт времени для задания name
    stop       - закончить отсчёт
    time       - вывести потраченное время
    help       - вывести help
    exit       - выходим из программы
]]
    printLine()
end

F.exit = function ()
    F.stop()
    F.time()
    os.exit()
end

F.time = tableOfWorkTime.print
F.start = timer.start
F.stop  = timer.stop



-- main
repeat
    local string = io.read()
    local cmd, rest = string:match("(%a+) (.*)")
    if not cmd then
        cmd = string
    end

    if F[cmd] then
        F[cmd](rest)
    end
until false
