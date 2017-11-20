function new.Main ()
    local private = {}
    private.localization    = new.Localization()
    private.tableIndex      = new.Index()
    private.tableOfWorkTime = new.ActiveTableOfWorkTime(private.tableIndex)
    private.show            = new.Show(private.tableIndex)
    private.timer           = new.Timer(private.tableOfWorkTime)

    private.help = function (cmd)
        if cmd == "show" then
            io.write(localization.helpShow)
        else    
            io.write(localization.help)
    end end

    private.exit = function ()
        private.timer.stop()
        private.tableOfWorkTime.print()
        os.exit()
    end

    private.userCommand = comands {
        [{"help",    "h"}]  = private.help,
        [{"exit",    "e"}]  = private.exit,
        [{"local",   "l"}]  = private.localization.set,
        [{"show",    "sh"}] = private.show.table,
        [{"work",    "wt"}] = private.tableOfWorkTime.print,
        [{"restart", "r"}]  = private.timer.restart,
        start               = private.timer.start,
        stop                = private.timer.stop,
    }

    local public = {}
    public.run = function ()
        private.localization.init()
        repeat
            local string = io.read()
            local cmd, arg = string:match("(%a+) (.*)")
            cmd = cmd or string
    
            if private.userCommand[cmd] then
                private.userCommand[cmd](arg)
            end
        until false
    end
    return copy(public)
end
