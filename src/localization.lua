local file = new.File("settings/lang.ini")

function setLocalization (code)
    local localizationTable = {
        ru = "local/ru.lua",
        en = "local/en.lua",
        eo = "local/eo.lua"
    }

    if localizationTable[code] then
        localization = dofile(localizationTable[code])
        file.write(code)
    elseif not localization then
        setLocalization("en")
end end

setLocalization(file.readIfExist())
