#!/bin/sh
# next line restarts using wish \
exec /bin/wish "$0" ${1+"$@"}

#-------------------------------------------------#
# what: search famfamfam icon app made in tcl tk
# author: Ricardo Victor Guiman II
# icons from famfamfam.com
#-------------------------------------------------#

# use your own dir
#lappend ::auto_path /ActiveTcl8.6.0.0/lib/
#lappend ::auto_path /lib/famfamfam1/
#lappend ::auto_path /lib/famfamfam_silk1/

package require famfamfam
package require famfamfam::silk
package require BWidget
package require tablelist 5.1

set famIconPath "/lib/famfamfam_silk1/silk/icons"
set searchPatt ""
set iconList [list]
set tb ""
set famCodeStr ""

proc getIconBasePattern { patt } {
    global famIconPath
    set pattPass "*$patt*"
    return [glob -type f -director $famIconPath -nocomplain -- $pattPass]
}

proc trimFiles { fileList } {
    set fileOnlyList [list]
    foreach curFile $fileList {
       lappend fileOnlyList [lindex [split $curFile "/"] end ]
    }
    return $fileOnlyList
}

proc setIcon { fileName kIndex } {
        global tb
        set tempIcon [::famfamfam::silk get [lindex [split $fileName "."] 0] ]
        $tb cellconfigure $kIndex,0 -image $tempIcon
    }

proc watchPatt { varname key op } {
    global searchPatt
    global iconList
    global tb
    $tb delete 0 end
    set iconList [lsort [trimFiles [ getIconBasePattern $searchPatt] ] ]
    foreach curIcon $iconList {
        set kIndex [$tb insertchildlist root end [list [list "" [lindex [split $curIcon "."] 0]] ] ]
        setIcon $curIcon $kIndex
        $tb configure -height 0
    }
}

proc iniGui { } {
    global searchPatt
    global tb
    global famCodeStr
    wm title . "fam Icon Search"
    wm maxsize . 400 800
    set fr1 [labelframe .fr1 -text "Search" -padx 5 -pady 5]
    label .labSearch -text "Pattern:"
    entry .entSearch -textvariable searchPatt
    label .labCode -text "FamCode:"
    entry .entCode -textvariable famCodeStr -state readonly
    button .buttExit -text "Exit" -command exit -image [::famfamfam::silk get door_out] -compound left
    
    set fr2 [labelframe .fr2 -text "Icons" -padx 5 -pady 5 ]
    set sw [::ScrolledWindow .listarea ]
    set tb [tablelist::tablelist .tab -showseparators 1 -columns { 0 "Icon" 0 "Name" } \
            -stretch all -width 40 -height 0 -selecttype row -stripebg gray90 -selectmode extended]
    $sw setwidget $tb
    
    grid .labSearch -in $fr1 -row 0 -sticky w
    grid .entSearch -in $fr1 -row 0 -column 1 -sticky ew
    grid .labCode -in $fr1 -row 1 -sticky w
    grid .entCode -in $fr1 -row 1 -column 1 -sticky ew
    grid .buttExit -in $fr1 -row 2 -column 1 -sticky e
    grid $fr1 -row 0 -padx 5 -pady 5 -sticky nesw
    grid $sw -in $fr2 -row 0 -sticky nesw
    grid $fr2 -row 1 -padx 5 -pady 5 -sticky nesw
    
    grid columnconfigure . 0 -weight 1
    grid rowconfigure . 1 -weight 1
    grid columnconfigure $fr1 1 -weight 1
    grid columnconfigure $fr2 0 -weight 1
    grid rowconfigure $fr2 0 -weight 1
    
    trace variable searchPatt w watchPatt
    bind [$tb bodytag] <Button-1> {
        foreach {tablelist::W tablelist::x tablelist::y} \
            [tablelist::convEventFields %W %x %y] {}
            set famCodeStr "set icon \[::famfamfam::silk get [lindex [$tb rowcget [$tb containing $tablelist::y] -text] 1]\]"
        }
}

iniGui
