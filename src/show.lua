function new.Show (index)
    local private = {}
    local public  = {}

    private.isInCurrentMonth = function (date)
        local currentMonth = os.date("%Y.%m.")
        return date:match(currentMonth .. "(.*)")
    end

    private.printTable = function (table)
        io.write(
            line ..
            table.tableBody() .. 
            line ..
            table.tableBottom{sumString = "ok"} ..
            line
        )
    end

    private.patchToTable = function (tableName)
        return "tables/".. tableName ..".lua"
    end

    private.addTable = function (sumTable, tableName)
        local tmpTable = new.TableOfWorkTime()
        tmpTable.load(private.patchToTable(tableName))
        for key, val in pairs(tmpTable.table()) do
            sumTable.addIn(key, val)
    end end

    private.generalTablePrint = function (filter)
        local sumTable, tmpTable = new.TableOfWorkTime(), new.TableOfWorkTime()
        for _, tableName in pairs(index.getIndex()) do   
            if filter(tableName) then
                private.addTable(sumTable, tableName)
        end end
        private.printTable(sumTable)
    end

    private.loadEndPrint = function (fileName)
        local table = new.TableOfWorkTime()
        table.load(fileName) 
        table.print()
    end

    public.table = function (tableName)
        local fileName = private.patchToTable(tableName)   

        if elem (tableName, {"sum table", "st"}) then
            private.generalTablePrint(funTrue)
        elseif elem(tableName, {"current month", "cm"}) then
            private.generalTablePrint(private.isInCurrentMonth)
        elseif new.File(fileName).exist() then
            private.loadEndPrint(fileName)
        else
            print(localization.tableNotExist)
    end end

    return copy(public)
end
