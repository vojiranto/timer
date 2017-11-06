local printLine = function ()
    io.write[[
-------------------------------------------------------------------------------
]]
end


local space = function(n)
    local space = ""
    for i = 1, n do
        space = "\t" .. space
    end
    return space
end


local sum = function (table)
    local result = 0
    for _, val in pairs(table) do
        result = result + val
    end
    return result
end


local tableToString = function (myTable, n)
    local m = n or 1
    local tmpTable = {}
    for k, v in pairs(myTable) do
        tmpTable[#tmpTable + 1] = k.." = "..v
    end
    return "{\n" ..
        space(m) .. table.concat(tmpTable, ",\n" .. space(m)) .. "\n" .. 
        space(m - 1) .. "}"
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
    end end

    private.writeInFile = function ()
        local file = io.open(private.fileName, "w")
        file:write(
            "return {\n" ..
            "\ttimeOfProgramStart = " .. private.timeOfProgramStart .. ",\n"..
            "\ttable = " .. tableToString(private.table, 2)         .. "\n" .. 
            "}"
        )
        file:close()
    end

    private.printTableBody = function ()
        for key, val in pairs(private.table) do
            print(key .. ": " .. round(val/3600, 1000))
    end end 

    private.printTableBottom = function ()
        local timeSum     = sum(private.table)
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
