return {
    help = [[
-------------------------------------------------------------------------------
SCTR - Simple Console Time Registrator
List of supported commands:
    start name      - start the time for the task "name";
    restart         - restart the current work ticket;
    stop            - finish off the task;
    work time       - show table of used time;
    show 2017.11.07 - show table of used time in 2017.11.07;
    help            - show help;
    local en        - change the language (en/eo/ru);
    exit            - exit from the program.
-------------------------------------------------------------------------------
]],
    helpShow      = [[
-------------------------------------------------------------------------------
The comand "show" reacts differently, depending on the argument.
    show 2017.11.07    - show table of used time in 2017.11.07;
    show current month - show table of used time in current month;
    show sum table     - show table of used time.
-------------------------------------------------------------------------------
]],
    timeSum       = "time sum:          ",
    workProcent   = "work time procent: ",
    startOf       = "start of ",
    tableNotExist = "The table does not exist.",
}
