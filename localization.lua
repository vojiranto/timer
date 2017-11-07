function setLocalization (code)
    local localizationTable = {
        ru = "local/ru.lua",
        en = "local/en.lua",
        eo = "local/eo.lua"
    }
    if localizationTable[code] then
        localization = dofile(localizationTable[code])
        writeFile("settings/lang.ini", code)
    elseif not localization then
        setLocalization("en")
end end


function initLocal ()
    local iniFile = io.open("settings/lang.ini", "r")
    if iniFile then
        local code = iniFile:read()
        setLocalization(code)
        iniFile:close()
    else
        setLocalization("en")
end end

initLocal()
