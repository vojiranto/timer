function funTrue  () return true  end
function funFalse () return false end

function round (n, i)
    if i then
        return round(n*i)/i
    else
        return n - n%1
end end


function copy (t)
    local result = {}
    for k, v in pairs(t) do
        result[k] = v
    end
    return result
end


local space = function (n)
    local space = ""
    for i = 1, n do
        space = "\t" .. space
    end
    return space
end


function keyToString (key)
    if type(key) == "string" then
        return "[\"" .. key .. "\"]"
    else
        return "[" .. key .. "]"
end end


function dataToString (elem, n)
    if type(elem) == "table" then
        local m = n or 1
        local tmpTable = {}
        for k, v in pairs(elem) do
            if type(v) ~= "function" then
                tmpTable[#tmpTable + 1] =
                    keyToString(k) .. " = " .. dataToString(v, m+1)
        end end
        return "{\n" ..
            space(m) .. table.concat(tmpTable, ",\n" .. space(m)) .. "\n" .. 
            space(m - 1) .. "}"
    elseif type(elem) == "string" then
        return "\"" .. elem .. "\""
    else
        return tostring(elem)
end end
