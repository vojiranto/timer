#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Название:    SCTR - Simple Console Time Registrator                       --
-- Версия:      0.0.3.9                                                      --
-- Автор:       Д.А. Павлюк                                                  --
-- Лицензия:    GPL                                                          --
-- Описание:    Программа для учёта рабочего времени.                        --
-------------------------------------------------------------------------------
local debug = false

-- устанавливаем значение по умолчанию.
function default(val, def)
    if val then
        return val
    else
        return def
end end

-- объект файл
function File (string)
    local private = {}
    private.string = string

    local public = {}
    -- запись в файл
    public.write = function (str, r)
        local r    = default(r, "a")    
        local file = io.open(private.string, r)
        file:write(str)
        file:close()
    end

    -- чтение из файла
    -- считывает всё содержимое файла или возвращает false
    public.read = function ()
        local file = io.open(private.string, "rb") 
        if file then
            local string = file:read("*all")
            file:close()
            return string
        end
        return false
    end
    return public
end


local table  = {}                   -- таблица затраченного времени
local st     = "stop"               -- текущее состояние
local ticket = ""                   -- текущая деятельность
local sTime  = os.time()            -- время начала работы программы
local time   = ""                   -- время начала работы над текущей задачей
local file   = File("work_log.md")  -- файл для записи лога
local F      = {}                   -- функции доступные пользователю
local M      = {}                   -- внутренние функции модуля

M.round = function(n, i)
    if i then
        return M.round(n*i)/i
    end
    return n - n%1
end

M.addZeroToNumber = function (n)
    if #tostring(x) < 2 then return "0"..x end
    return ""..x
end

-- s => h:m:s
M.date = function (n)
    local s = M.round(n%60)
    local m = M.round(n/60%60)
    local h = M.round(n/3600%24)
    return h..":"..M.addZeroToNumber(m)..":"..M.addZeroToNumber(s)
end

-- test s => h:m:s
if debug and "1:01:05" ~= M.date(3665) then 
    print(" M.date(3665) = " .. M.date(3665))
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
    local now = os.time()
    local timeSum = 0
    M.printLine()
    for key, val in pairs(table) do
        print(key .. ": " .. M.round(val/3600, 1000))
        timeSum = timeSum + val
    end
    print("time sum:  " .. M.round(timeSum/3600, 1000))
    print("work time: " .. M.round(timeSum/(now - sTime)*100) .. "%")
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
    file.write(outString)
end


M.addInTable = function(t, key, val)
    if t[key] then
        t[key] = t[key] + val
    else
        t[key] = val
end end


M.startOfTheTimer = function (rest)
    if st == "start" then F.stop() end

    time   = os.time()
    ticket = default(rest, "work")
    st     = "start"
    
    M.printToConsoleAndInFile("start of ".. ticket)
end
F.start = M.startOfTheTimer


M.stopOfTheTimer = function ()
    if st == "start" then
        st = "stop"
        local tmp_diff = os.time() - time
        M.addInTable(table, ticket, tmp_diff)
        M.printToConsoleAndInFile(M.date(tmp_diff))
end end
F.stop = M.stopOfTheTimer


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
