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


function printToConsoleAndInFile (string)
    local outString = os.date("%X") .. ": " .. string .. ".\n"
    
    io.write(outString) 

    local file      = io.open("work_log.md", "a")
    file:write(outString)
    file:close()
end
