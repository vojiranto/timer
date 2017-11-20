--------------------------------------------------------------------------------
-- Name:            Functions                                                 --
-- Dependencies:    -                                                         --
--------------------------------------------------------------------------------
function funTrue  () return true  end
function funFalse () return false end


-- округляем число n до i-той части.
function round (n, i)
    if i then
        return round(n*i)/i
    else
        return n - n%1
end end


-- суммируем элементы таблицы
-- sum {1, 2, 3} == 6
function sum (table)
    local result = 0
    for _, val in pairs(table) do
        result = result + val
    end
    return result
end


-- копируем таблицу
function copy (t)
    local result = {}
    for k, v in pairs(t) do
        result[k] = v
    end
    return result
end


-- создаём отступ шириной в n.
local space = function (n)
    local space = ""
    for i = 1, n do
        space = "\t" .. space
    end
    return space
end


-- входит ли икс входит в таблицу?
function elem (x, list)
    for k, v in pairs (list) do
        if v == x then
            return true
end end end


-- преобразовать ключ в строку
function keyToString (key)
    if type(key) == "string" then
        return "[\"" .. key .. "\"]"
    else
        return "[" .. key .. "]"
end end


-- сериализация данных
function dataToString (elem, n)
    if type(elem) == "table" then
        local m = n or 1
        local tmpTable = {}
        for k, v in pairs(elem) do
            if type(v) ~= "function" then
                tmpTable[#tmpTable + 1] =
                    keyToString(k) .. " = " .. dataToString(v, m + 1)
        end end
        return "{\n" ..
            space(m) .. table.concat(tmpTable, ",\n" .. space(m)) .. "\n" .. 
            space(m - 1) .. "}"
    elseif type(elem) == "string" then
        return "\"" .. elem .. "\""
    else
        return tostring(elem)
end end


-- строим множество, по которому легко выяснить входить ли в него элемент.
function set (t)
    local res = {}
    for v, k in pairs(t) do
        res[k] = v
    end
    return res
end


--[[
-- список команд, которым нужно присвоить действия.
userCommand = comands {
    [{"cmd1", "cmd2"}] = fun1,
    [{"cmd3", "cmd4"}] = fun2,
    cmd5               = fun3,
}]]
function comands (com)
    local res = {}
    for key, val in pairs(com) do
        if type(key) == "table" then 
            for _, k in pairs(key) do
                res[k] = val
            end
        else
            res[key] = val
    end end
    return res
end
