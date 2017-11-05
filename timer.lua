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
