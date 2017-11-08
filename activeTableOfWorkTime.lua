function ActiveTableOfWorkTime()
    local private = {
            fileName = "tables/".. os.date("%Y.%m.%d")..".lua",
    }
    local public  = TableOfWorkTime ()
    local parent  = copy(public)

    public.print = function ()
        public.setTimeOfProgramStop()
        parent.writeTableInFile(private.fileName)
        parent.print()
    end

    public.addIn = function (key, val)
        parent.addIn(key, val)
        parent.setTimeOfProgramStop()
        parent.writeTableInFile(private.fileName)
    end

    parent.load(private.fileName)

    return public
end
