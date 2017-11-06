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
