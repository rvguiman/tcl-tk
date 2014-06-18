#!/bin/sh
# next line starts using wish \
exec /bin/wish "$0" ${1+"$@"}

#----------------------------------------------------------
# what: tcl sqlite sample
# author: ricardo
# sample sqlite command command
# CREATE TABLE tab(a int, b text)
# INSERT INTO tab VALUES(1,'hello world')
# SELECT * FROM tab ORDER BY a
# INSERT INTO tab VALUES(3,$SampleVar)
#----------------------------------------------------------

package require sqlite3

set dBaseName "./test.db"
set qEnt ""
set dBaseStat 0

proc setDbaseValues { databaseName } {
    global dBaseName
    set dBaseName $databaseName
}

proc openDbase {  } {
    global dBaseName
    sqlite3 dbcm $dBaseName
    .buttOpen configure -state disabled
    .buttClose configure -state normal
    .buttQuery configure -state normal
}

proc queryDbase { { queString "" } } {
    puts $queString
    set res [dbcm eval $queString]
    puts "Out -> $res"
}

proc closeDbase { } {
    dbcm close
    .buttOp configure -state normal
    .buttCl configure -state disabled
    .buttQue configure -state disabled
}

proc sfExit { } {
    global dBaseStat
    if { $dBaseStat } {
        closeDb
        set dBaseStat 0
    }
    exit
}

proc iniGui { } {
    global qEnt
    global dBaseName
    
    label .labdBaseName -text "Database Name:"
    entry .entdBaseName -textvariable dBaseName
    button .buttOp -text "Open" -command { openDbase }
    label .labQuery -text "Query String:"
    entry .entQuery -textvariable qEnt
    button .buttQue -text "Query" -command { queryDbase $qEnt } -state disabled
    button .buttCl -text "Close DB" -command closeDbase -state disabled
    button .buttExit -text "Exit" -command sfExit
    
    grid .labdBaseName .entdBaseName .buttOpen -row 0 -sticky nesw
    grid .labQuery .entQuery .buttQuery -row 1 -sticky nesw
    grid .buttClose .buttExit -row 2 -sticky nesw
}

iniGui
