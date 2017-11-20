--------------------------------------------------------------------------------
-- Name:            Localization                                              --
-- Dependencies:    Functions, File                                           --
--------------------------------------------------------------------------------
function new.Localization ()
    local file   = new.File("settings/lang.ini")
    local public = {}
    
    public.set = function (code)
        if elem(code, {"ru", "en", "eo"}) then
            localization = dofile("local/" .. code .. ".lua")
            file.write(code)
        elseif not localization then
            public.set ("en")
    end end
    
    public.init = function ()
        public.set(file.readIfExist())
    end

    return copy(public) 
end
