#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Название:    SCTR - Simple Console Time Registrator                       --
-- Версия:      0.0.3.6                                                      --
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


-- s => h:m:s
M.date = function (n)
    local s = M.round(n%60)
    local m = M.round(n/60%60)
    local h = M.round(n/3600%24)
    local f = function (x)
        if #tostring(x) < 2 then
            return "0"..x
        end
        return ""..x
    end
    return h..":"..f(m)..":"..f(s)
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


-- напечатать время
F.time = function ()
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


-- выходим из программы
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


-- стартуем таймер
F.start = function (rest)
    if st == "start" then 
        F.stop()
    end
    rest = default(rest, "work")

    time   = os.time()
    ticket = rest
    st     = "start"
    
    M.printToConsoleAndInFile("start of ".. ticket)
end


-- останавливаем таймер
F.stop = function ()
    if st == "start" then
        st = "stop"
        -- время между стартом и завершением
        local tmp_diff = os.time() - time
        if not table[ticket] then
            table[ticket] = tmp_diff   
        else
            table[ticket] = table[ticket] + tmp_diff
        end

        M.printToConsoleAndInFile(M.date(tmp_diff))
end end


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
