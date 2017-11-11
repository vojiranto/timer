function Show (index)
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

    private.generalTablePrint = function (filter)
        local sumTable, tmpTable = TableOfWorkTime(), TableOfWorkTime()
        for _, tableName in pairs(index.getIndex()) do   
            if filter and (not private.isInCurrentMonth(tableName)) then
                break
            end

            tmpTable.load("tables/".. tableName ..".lua")
            for key, val in pairs(tmpTable.table()) do
                sumTable.addIn(key, val)
        end end

        private.printTable(sumTable)
    end

    private.sumTable     = function () private.generalTablePrint()     end
    private.currentMonth = function () private.generalTablePrint("ok") end

    public.table = function (tableName) 
        if tableName == "sum table" then
            private.sumTable()
            return    
        end

        if tableName == "current month" then
            private.currentMonth()
            return
        end

        local fileName = "tables/".. tableName ..".lua"
        if File(fileName).exist() then
            local table = TableOfWorkTime()
            table.load(fileName) 
            table.print()
        else
            print(localization.tableNotExist)
    end end

    return copy(public)
end
