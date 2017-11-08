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
