setLocalization = function (code)
    local localizationTable = {
        ru = "local/ru.lua",
        en = "local/en.lua",
        eo = "local/eo.lua"
    }
    if localizationTable[code] then
        localization = dofile(localizationTable[code])
        local iniFile = io.open("settings/lang.ini", "w")
        iniFile:write(code)
        iniFile:close()
    elseif not localization then
        setLocalization("en")
end end


local iniFile = io.open("settings/lang.ini", "r")
if iniFile then
    local code = iniFile:read()
    setLocalization(code)
    iniFile:close()
else
    setLocalization("en")
end
