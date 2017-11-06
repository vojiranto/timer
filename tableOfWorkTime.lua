local printLine = function ()
    io.write[[
-------------------------------------------------------------------------------
]]
end


function TableOfWorkTime ()
    local private = {
        fileName           = "tables/".. os.date("%Y.%m.%d")..".lua",
        timeOfProgramStart = os.time(),
        table              = {}
    }

    private.load = function ()
        local file = io.open(private.fileName, "r")
        if file then
            io.close(file)
            local data                 = dofile(private.fileName)
            private.table              = data.table
            private.timeOfProgramStart = data.timeOfProgramStart
        end
    end

    private.writeInFile = function ()
        local file = io.open(private.fileName, "w")
        file:write(
            "return {\n" ..
            "    timeOfProgramStart = " .. private.timeOfProgramStart .. ",\n"..
            "    table = {\n"
        )
        for k, v in pairs (private.table) do
            file:write(
            "        "..k.." = ".. v .. ",\n"
            )
        end
        file:write(
            "    }\n" ..
            "}\n"
        )
        file:close()
    end

    private.timeSum = function ()
        local sum = 0
        for _, val in pairs(private.table) do
            sum = sum + val
        end
        return sum
    end

    private.printTableBody = function ()
        for key, val in pairs(private.table) do
            print(key .. ": " .. round(val/3600, 1000))
        end
    end 

    private.printTableBottom = function ()
        local timeSum     = private.timeSum()
        local workProcent = timeSum/(os.time() - private.timeOfProgramStart)*100
        io.write(
            localization.timeSum     .. round(timeSum/3600, 1000) ..  "\n" ..
            localization.workProcent .. round(workProcent,  10)   .. "%\n"
        )
    end

    local public = {}

    public.print = function ()
        printLine()
        private.printTableBody()
        printLine()
        private.printTableBottom()
        printLine()        
    end

    public.addIn = function (key, val)
        private.table[key] = (private.table[key] or 0) + val
        private.writeInFile()
    end

    private.load()

    return public
end
