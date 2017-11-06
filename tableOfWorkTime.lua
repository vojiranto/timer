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
            file:write("        "..k.." = ".. v .. ",\n")
        end
        file:write("    }\n")
        file:write("}\n")
        file:close()
    end

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
        private.table[key] = (private.table[key] or 0) + val
        private.writeInFile()
    end

    private.load()

    return public
end
