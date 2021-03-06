--------------------------------------------------------------------------------
-- Name:            ActiveTableOfWorkTime                                     --
-- Dependencies:    Functions, File, Localization, TableOfWorkTime, Index     --
--------------------------------------------------------------------------------
function new.ActiveTableOfWorkTime(tableIndex)
    local private = {
        fileName  = "tables/".. os.date("%Y.%m.%d")..".lua",
    }

    local public  = new.TableOfWorkTime ()
    local parent  = copy(public)

    public.update = function ()
        parent.setTimeOfProgramStop()
        tableIndex.insert()
        tableIndex.write()        
        parent.writeTableInFile(private.fileName)
    end

    public.print = function ()
        public.update()
        parent.print()
    end

    public.addIn = function (key, val)
        parent.addIn(key, val)
        public.update()
    end

    parent.load(private.fileName)
    public.update()

    return copy(public)
end
