#!/usr/bin/luajit
-------------------------------------------------------------------------------
-- Name:        SCTR - Simple Console Time Registrator                       --
-- Version:     0.2.4.6                                                      --
-- Author:      D.A. Pavlyuk                                                 --
-- License:     GPL                                                          --
-- Description: The program for the account of working hours.                --
-------------------------------------------------------------------------------

function dofiles (files)
    for _, fileName in pairs(files) do
        dofile("src/".. fileName .. ".lua")
end end

new = {}
dofiles {
    "functions",
    "file",    
    "localization",
    "index",
    "tableOfWorkTime",
    "activeTableOfWorkTime",
    "timer",
    "show",
    "main",
}

new.Main().run()
