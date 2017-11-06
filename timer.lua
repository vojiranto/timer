local addZeroToNumber = function (n)
    if #tostring(n) < 2 then 
        return "0"..n
    else
        return ""..n
end end


-- s => h:m:s
local toNormalTimeFormat = function  (n)
    local s = round(n%60)
    local m = round(n/60%60)
    local h = round(n/3600%24)
    return h..":"..addZeroToNumber(m)..":"..addZeroToNumber(s)
end


local printToConsoleAndInFile = function (string)
    local outString = os.date("%X") .. ": " .. string .. ".\n"
    
    io.write(outString) 

    local file      = io.open("work_log.md", "a")
    file:write(outString)
    file:close()
end


function Timer (tableOfWorkTime)
    local private = {}
    local public  = {}
    public.start = function (ticketName)
        public.stop()
        private = {
            timeOfStart = os.time(),
            ticketName  = ticketName or "work",
            state       = "start",
        }
        printToConsoleAndInFile("start of " .. private.ticketName)
    end

    public.stop = function ()
        if private.state ~= "start" then return end
        private.state = "stop"
        local tmp_diff = os.time() - private.timeOfStart
        tableOfWorkTime.addIn(private.ticketName, tmp_diff)
        printToConsoleAndInFile(toNormalTimeFormat(tmp_diff))
    end
    return public
end
