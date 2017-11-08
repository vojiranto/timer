local line = [[
-------------------------------------------------------------------------------
]]

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
        timeOfProgramStart = os.time(),
        timeOfProgramStop  = os.time(),
        table              = {}
    }
    local public = {}

    public.load = function (fileName)
        if fileExist(fileName) then
            local data                 = dofile(fileName)
            private.table              = data.table
            private.timeOfProgramStart = data.timeOfProgramStart
            private.timeOfProgramStop  = data.timeOfProgramStop
    end end

    private.tableBody = function ()
        local tmpTable = {}
        for key, val in pairs(private.table) do
            tmpTable[#tmpTable + 1] = key .. ": " .. round(val/3600, 1000)
        end
        return table.concat(tmpTable, "\n") .. "\n"
    end

    private.programWorkTime = function ()
        return private.timeOfProgramStop - private.timeOfProgramStart
    end

    private.tableBottom = function ()
        local timeSum     = sum(private.table)
        local workProcent = timeSum/private.programWorkTime() * 100
        return
            localization.timeSum     .. round(timeSum/3600, 1000) ..  "\n" ..
            localization.workProcent .. round(workProcent,  10)   .. "%\n"
    end

    public.setTimeOfProgramStoping = function ()
        private.timeOfProgramStoping = os.time() 
    end

    public.print = function ()
        io.write(
            line ..
            private.tableBody() .. line .. private.tableBottom() .. 
            line
        )
    end

    public.writeTableInFile = function (fileName)
        writeFile(fileName,
            "return {\n" ..
            "\ttimeOfProgramStart = " .. private.timeOfProgramStart .. ",\n" ..
            "\ttimeOfProgramStop  = " .. private.timeOfProgramStop  .. ",\n" ..
            "\ttable = " .. tableToString(private.table, 2)         .. "\n"  .. 
            "}"
        )
    end

    public.addIn = function (key, val)
        private.table[key] = (private.table[key] or 0) + val
    end

    return public
end
