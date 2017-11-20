--------------------------------------------------------------------------------
-- Name:            Index                                                     --
-- Dependencies:    Functions, File,                                          --
--------------------------------------------------------------------------------
function new.Index ()
    local indexPath = "tables/index.lua"
    local file = new.File(indexPath)
    local private = {}
    local public = {}
    
    private.load = function ()
        if file.exist() then
            private.index = dofile(indexPath)
    end end
    
    public.insert = function ()
        if not private.index then
            private.index = {}
            private.index[1] = os.date("%Y.%m.%d")
        elseif private.index[#private.index] ~= os.date("%Y.%m.%d") then
            private.index[#private.index + 1] = os.date("%Y.%m.%d")
    end end

    public.write = function ()
        file.write("return " .. dataToString(private.index))
    end

    public.getIndex = function ()
        return copy(private.index)
    end

    private.load()
    return copy(public)
end
