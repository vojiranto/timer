line = [[
-------------------------------------------------------------------------------
]]


local sum = function (table)
    local result = 0
    for _, val in pairs(table) do
        result = result + val
    end
    return result
end


function new.TableOfWorkTime ()
    local private = {
        timeOfProgramStart = os.time(),
        timeOfProgramStop  = os.time(),
        table              = {}
    }
    local public = {}

    public.load = function (fileName)
        if new.File(fileName).exist() then
            for k, v in pairs(dofile(fileName)) do
                private[k] = v
    end end end

    public.tableBody = function ()
        local tmpTable = {}
        for key, val in pairs(private.table) do
            tmpTable[#tmpTable + 1] = key .. ": " .. round(val/3600, 1000)
        end
        return table.concat(tmpTable, "\n") .. "\n"
    end

    private.programWorkTime = function ()
        return private.timeOfProgramStop - private.timeOfProgramStart
    end

    public.tableBottom = function (ok)
        local sumString, procentString = "", ""
        local timeSum = sum(private.table)
        if ok.sumString then
            sumString = localization.timeSum .. round(timeSum/3600, 1000) .. "\n"
        end
        
        if ok.procentString then
            local workProcent = timeSum/private.programWorkTime() * 100
            procentString = localization.workProcent .. round(workProcent, 10) .. "%\n"
        end
        
        return sumString .. procentString
    end

    public.setTimeOfProgramStop = function ()
        private.timeOfProgramStop = os.time() 
    end

    public.print = function ()
        io.write(
            line ..
            public.tableBody() .. 
            line .. 
            public.tableBottom{sumString = "ok", procentString = "ok"} .. 
            line
        )
    end

    public.writeTableInFile = function (fileName)
        new.File(fileName).write("return " .. dataToString(private, 1))
    end

    public.addIn = function (key, val)
        private.table[key] = (private.table[key] or 0) + val
    end
    
    public.table = function ()
        return copy(private.table)
    end

    return copy(public)
end
