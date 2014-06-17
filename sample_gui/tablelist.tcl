#!/bin/sh
# next line starts tclsh \
exec /bin/wish "$0" ${1+"$@"}

#--------------------------------------------------------
# what: sample using tablelist package
# author: ricardo
#--------------------------------------------------------

# append auto_path with tcllib package
# lappend ::auto_path /tcl/lib/tcllib

package require tablelist 5.1

proc insertData { dataRowList } {
    set dataId [.tab insertchildlist root end $dataRowList]
}

proc iniGui { } {
    labelframe .oneFr -text "Table List Sample" -padx 5 -pady 5  
    set scrw [::ScrolledWindow .tbarea]
    set tb [tablelist::tablelist .tab -showseparators 1 -columns { 0 "Column1" 0 "Column2" } -stretch all \
            -background white -yscrollcommand {.sy set} -xscrollcommand {.sx set} -stripebg gray90]
    $scrw setwidget $tb   
    grid $scrw -in .oneFr -row 0 -column 0 -sticky nesw
    grid .oneFr -row 0 -column 0 -sticky nesw  -padx 5 -pady 5
    
    # for weight, use the container path but point to column and row of child widgets
    grid columnconfigure .oneFr 0 -weight 1
    grid rowconfigure .oneFr 0 -weight 1
}

iniGui
insertData [list "data1" "data2"]
