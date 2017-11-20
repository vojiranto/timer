--------------------------------------------------------------------------------
-- Name:            Timer                                                     --
-- Dependencies:    Functions, File, Localization, TableOfWorkTime, Index,    --
--                  ActiveTableOfWorkTime                                     --
--------------------------------------------------------------------------------
local addZeroToNumber = function (n)
    if #tostring(n) < 2 then 
        return "0"..n
    else
        return ""..n
end end


-- s => h:m:s
local toNormalTimeFormat = function (n)
    local s = round(n%60)
    local m = round(n/60%60)
    local h = round(n/3600%24)
    return h..":"..addZeroToNumber(m)..":"..addZeroToNumber(s)
end


local printToConsoleAndInFile = function (string)
    local outString = os.date("%X") .. ": " .. string .. ".\n"
    io.write(outString)
    new.File("work_log.md").write(outString, "a")
end


function new.Timer (tableOfWorkTime)
    local private = {}
    local public  = {}
    
    public.start = function (ticketName)
        public.stop()
        private = {
            timeOfStart = os.time(),
            ticketName  = ticketName or "work",
            state       = "started",
        }
        printToConsoleAndInFile(localization.startOf .. private.ticketName)
    end

    public.stop = function ()
        if private.state ~= "started" then return end
        private.state  = "stoped"
        local tmp_diff = os.time() - private.timeOfStart
        tableOfWorkTime.addIn(private.ticketName, tmp_diff)
        printToConsoleAndInFile(toNormalTimeFormat(tmp_diff))
    end

    public.restart = function ()
        public.start(private.ticketName)
    end

    return copy(public)
end
