local space = function(n)
    local space = ""
    for i = 1, n do
        space = "\t" .. space
    end
    return space
end


function round (n, i)
    if i then
        return round(n*i)/i
    else
        return n - n%1
end end


function sum (table)
    local result = 0
    for _, val in pairs(table) do
        result = result + val
    end
    return result
end


function tableToString (myTable, n)
    local m = n or 1
    local tmpTable = {}
    for k, v in pairs(myTable) do
        tmpTable[#tmpTable + 1] = k.." = "..v
    end
    return "{\n" ..
        space(m) .. table.concat(tmpTable, ",\n" .. space(m)) .. "\n" .. 
        space(m - 1) .. "}"
end

