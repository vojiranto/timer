#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Name:        SCTR - Simple Console Time Registrator                       --
-- Version:     0.2.4.7                                                      --
-- Author:      D.A. Pavlyuk                                                 --
-- License:     GPL                                                          --
-- Description: The program for the account of working hours.                --
-------------------------------------------------------------------------------
function dolibs(libs)
    for _, fileName in pairs(libs) do
        dofile("../../libs/" .. fileName .. "/main.lua")
end end

function dofiles (files)
    for _, fileName in pairs(files) do
        dofile("src/".. fileName .. ".lua")
end end

new = {}

dolibs {
    "functions",
    "file",
}

dofiles {
    "localization",
    "index",
    "tableOfWorkTime",
    "activeTableOfWorkTime",
    "timer",
    "show",
    "main",
}

new.Main().run()
