local printLine = function ()
    io.write[[
-------------------------------------------------------------------------------
]]
end


local sum = function (table)
    local result = 0
    for _, val in pairs(table) do
        result = result + val
    end
    return result
end


local space = function(n)
    local space = ""
    for i = 1, n do
        space = "\t" .. space
    end
    return space
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
        timeOfProgramStart   = os.time(),
        timeOfProgramStoping = os.time(),
        table                = {}
    }
    local public = {}

    public.load = function (fileName)
        local file = io.open(fileName, "r")
        if file then
            io.close(file)
            local data                   = dofile(fileName)
            private.table                = data.table
            private.timeOfProgramStart   = data.timeOfProgramStart
            private.timeOfProgramStoping = data.timeOfProgramStoping
    end end

    private.printTableBody = function ()
        for key, val in pairs(private.table) do
            print(key .. ": " .. round(val/3600, 1000))
    end end 

    public.programWorkTime = function ()
        return private.timeOfProgramStoping - private.timeOfProgramStart
    end

    private.printTableBottom = function ()
        local timeSum         = sum(private.table)
        local workProcent     = timeSum/public.programWorkTime() * 100
        io.write(
            localization.timeSum     .. round(timeSum/3600, 1000) ..  "\n" ..
            localization.workProcent .. round(workProcent,  10)   .. "%\n"
        )
    end

    public.setTimeOfProgramStoping = function ()
        private.timeOfProgramStoping = os.time() 
    end

    public.print = function ()
        printLine()
        private.printTableBody()
        printLine()
        private.printTableBottom()
        printLine()        
    end

    public.writeTableInFile = function (fileName)
        writeFile(fileName,
            "return {\n" ..
            "\ttimeOfProgramStart   = " .. private.timeOfProgramStart   .. ",\n" ..
            "\ttimeOfProgramStoping = " .. private.timeOfProgramStoping .. ",\n" ..
            "\ttable = " .. tableToString(private.table, 2)             .. "\n"  .. 
            "}"
        )
    end

    public.addIn = function (key, val)
        private.table[key] = (private.table[key] or 0) + val
    end

    return public
end

function showTable (tableName) 
    local fileName = "tables/".. tableName ..".lua"
    local file = io.open(fileName, "r")
    if file then
        file:close()
        local table    = TableOfWorkTime()
        table.load(fileName) 
        table.print()
    else
        print(localization.tableNotExist)
end end
