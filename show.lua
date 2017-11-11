function Show (index)
    local private = {}
    local public  = {}

    private.sumTable = function () 
        local sumTable, tmpTable = TableOfWorkTime(), TableOfWorkTime()
        for _, tableName in pairs(index.getIndex()) do   
            tmpTable.load("tables/".. tableName ..".lua")
            for key, val in pairs(tmpTable.table()) do
                sumTable.addIn(key, val)
        end end

        io.write(
            line ..
            sumTable.tableBody() .. 
            line ..
            sumTable.tableBottom{sumString = "ok"} ..
            line
        )
    end

    public.table = function (tableName) 
        if tableName == "sum table" then
            private.sumTable()
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
