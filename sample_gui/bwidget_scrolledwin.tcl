#!/bin/sh
# next line start tclsh
exec /bin/wish "$0" ${1+"@"}

#-------------------------------------------------------------------------------------------------#
# what: auto scrolled window ( scroll bars are hidden if there is enough space for the content )
# author: Ricardo
#-------------------------------------------------------------------------------------------------#

# append your autopath for bwidget package
# lappend ::auto_path /Tcl/package/lib/your_path

package require BWidget

proc iniGui { } {
    labelframe .consoleFr -text "console" -padx 5 -pady 5
    set scrWin [::ScrolledWindow .textWindow]
    set textPath [text [$scrWin getFrame].textarea]
    $scrWin setwidget $textPath
    
    grid $scrWin -in .consoleFr -row 0 -column 0 -sticky nesw
    grid .consoleFr -row 0 -column 0 -sticly nesw
    
    # use auto weight 1 to stretch on window resize.(Use the container path but column and row of widget inside)
    grid columnconfigure .consoleFr 0 -weight 1
    grid rowconfigure .consoleFr 0 -weight 1
}

iniGui

