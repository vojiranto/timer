function File(fileName) 
    local public = {}
    public.exist = function ()
        local file = io.open(fileName, "r")
        if file then
            file:close()
            return true
    end end

    public.write = function (string, r)
        local file = io.open(fileName, r or "w")
        file:write(string)
        file:close()
    end
    
    public.read = function (string, r, m)
        local file = io.open(fileName, r or "r")
        local tmp = file:read(m or "*all")
        file:close()
        return tmp
    end
    
    return public
end

