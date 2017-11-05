#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Название:    SCTR - Simple Console Time Registrator                       --
-- Версия:      0.0.3.11                                                     --
-- Автор:       Д.А. Павлюк                                                  --
-- Лицензия:    GPL                                                          --
-- Описание:    Программа для учёта рабочего времени.                        --
-------------------------------------------------------------------------------
local debug = true

function default(val, def)
    if val then
        return val
    else
        return def
end end


function File (string)
    local private = {}
    private.string = string

    local public = {}
    public.write = function (str, r)
        local file = io.open(private.string, default(r, "a"))
        file:write(str)
        file:close()
    end
    return public
end


local table              = {}
local timeOfProgramStart = os.time()
local F                  = {}
local M                  = {}

M.round = function(n, i)
    if i then
        return M.round(n*i)/i
    end
    return n - n%1
end

M.addZeroToNumber = function (n)
    if #tostring(n) < 2 then return "0"..n end
    return ""..n
end

-- s => h:m:s
M.toNormalTimeFormat = function (n)
    local s = M.round(n%60)
    local m = M.round(n/60%60)
    local h = M.round(n/3600%24)
    return h..":"..M.addZeroToNumber(m)..":"..M.addZeroToNumber(s)
end

-- test s => h:m:s
if debug and "1:01:05" ~= M.toNormalTimeFormat(3665) then 
    print(" M.date(3665) = " .. M.toNormalTimeFormat(3665))
end


M.printLine = function ()
    io.write[[
-------------------------------------------------------------------------------
]]
end

F.help = function ()
    M.printLine()
    io.write[[
SCTR - Simple Console Time Registrator
Список поддерживаемых команд:
    start name - начать отсчёт времени для задания name
    stop       - закончить отсчёт
    time       - вывести потраченное время
    help       - вывести help
    exit       - выходим из программы
]]
    M.printLine()
end


M.printTableOfTime = function ()
    local timeSum = 0
    M.printLine()
    for key, val in pairs(table) do
        print(key .. ": " .. M.round(val/3600, 1000))
        timeSum = timeSum + val
    end
    print("time sum:  " .. M.round(timeSum/3600, 1000))
    print("work time: " .. 
        M.round(timeSum/(os.time() - timeOfProgramStart)*100) .. "%"
    )
    M.printLine()
end
F.time = M.printTableOfTime


F.exit = function()
    F.stop()
    F.time()
    os.exit()
end


M.printToConsoleAndInFile = function (string)
    local outString = os.date("%X") .. ": " .. string .. ".\n"
    io.write(outString) 
    File("work_log.md").write(outString)
end


M.addInTable = function(t, key, val)
    if t[key] then
        t[key] = t[key] + val
    else
        t[key] = val
end end

function Timer ()
    local private = {}
    local public  = {}
    public.start = function (ticketName)
        public.stop()
        private = {
            timeOfStart = os.time(),
            ticketName  = default(ticketName, "work"),
            state       = "start",
        }
        M.printToConsoleAndInFile("start of " .. private.ticketName)
    end

    public.stop = function ()
        if private.state ~= "start" then return end
        private.state = "stop"
        local tmp_diff = os.time() - private.timeOfStart
        M.addInTable(table, private.ticketName, tmp_diff)
        M.printToConsoleAndInFile(M.toNormalTimeFormat(tmp_diff))
    end

    return public
end

local timer = Timer()
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
