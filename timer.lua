#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Название:    SCTR - Simple Console Time Registrator                       --
-- Версия:      0.0.4.1                                                      --
-- Автор:       Д.А. Павлюк                                                  --
-- Лицензия:    GPL                                                          --
-- Описание:    Программа для учёта рабочего времени.                        --
-------------------------------------------------------------------------------
function default(val, def)
    if val then
        return val
    else
        return def
end end


function round (n, i)
    if i then
        return round(n*i)/i
    end
    return n - n%1
end


function addZeroToNumber (n)
    if #tostring(n) < 2 then return "0"..n end
    return ""..n
end


-- s => h:m:s
function toNormalTimeFormat (n)
    local s = round(n%60)
    local m = round(n/60%60)
    local h = round(n/3600%24)
    return h..":"..addZeroToNumber(m)..":"..addZeroToNumber(s)
end


function printLine ()
    io.write[[
-------------------------------------------------------------------------------
]]
end


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


function TableOfWorkTime ()
    local private = {
        timeOfProgramStart = os.time(),
        table = {}
    }

    local public = {}
    public.print = function ()
        local timeSum = 0
        printLine()
        for key, val in pairs(private.table) do
            print(key .. ": " .. round(val/3600, 1000))
            timeSum = timeSum + val
        end
        print("time sum:  " .. round(timeSum/3600, 1000))
        print("work time: " .. 
            round(timeSum/(os.time() - private.timeOfProgramStart)*100) .. "%"
        )
        printLine()
    end

    public.addIn = function(key, val)
        if private.table[key] then
            private.table[key] = private.table[key] + val
        else
            private.table[key] = val
    end end

    return public
end

local tableOfWorkTime = TableOfWorkTime()
F.time = tableOfWorkTime.print


F.exit = function()
    F.stop()
    F.time()
    os.exit()
end


function printToConsoleAndInFile (string)
    local outString = os.date("%X") .. ": " .. string .. ".\n"
    
    io.write(outString) 

    local file      = io.open("work_log.md", "a")
    file:write(outString)
    file:close()
end


function Timer (tableOfWorkTime)
    local private = {}
    local public  = {}
    public.start = function (ticketName)
        public.stop()
        private = {
            timeOfStart = os.time(),
            ticketName  = default(ticketName, "work"),
            state       = "start",
        }
        printToConsoleAndInFile("start of " .. private.ticketName)
    end

    public.stop = function ()
        if private.state ~= "start" then return end
        private.state = "stop"
        local tmp_diff = os.time() - private.timeOfStart
        tableOfWorkTime.addIn(private.ticketName, tmp_diff)
        printToConsoleAndInFile(toNormalTimeFormat(tmp_diff))
    end
    return public
end

local timer = Timer(tableOfWorkTime)
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
