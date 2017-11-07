function round (n, i)
    if i then
        return round(n*i)/i
    else
        return n - n%1
end end


function writeFile (fileName, string, r)
    local file = io.open(fileName, r or "w")
    file:write(string)
    file:close()
end
