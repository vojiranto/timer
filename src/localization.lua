function new.Localization ()
    local file   = new.File("settings/lang.ini")
    local public = {}
    
    public.set = function (code)
        local table = {
            ru = "local/ru.lua",
            en = "local/en.lua",
            eo = "local/eo.lua"
        }

        if table[code] then
            localization = dofile(table[code])
            file.write(code)
        elseif not localization then
            setLocalization("en")
    end end
    
    public.init = function ()
        public.set(file.readIfExist())
    end

    return copy(public) 
end
