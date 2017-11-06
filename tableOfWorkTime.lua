local printLine = function ()
    io.write[[
-------------------------------------------------------------------------------
]]
end

function TableOfWorkTime ()
    local private = {
        timeOfProgramStart = os.time(),
        table = {}
    }

    local public = {}
    public.print = function ()
        local timeSum = 0
        printLine()
        for key, val in pairs(private.table) do
            print(key .. ": " .. round(val/3600, 1000))
            timeSum = timeSum + val
        end
        print("time sum:  " .. round(timeSum/3600, 1000))
        print("work time: " .. 
            round(timeSum/(os.time() - private.timeOfProgramStart)*100) .. "%"
        )
        printLine()
    end

    public.addIn = function (key, val)
        private.table[key] = private.table[key] or 0 + val
    end

    return public
end
