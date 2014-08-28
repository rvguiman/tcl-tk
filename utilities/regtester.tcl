#!/bin/sh
# next line restarts using wish \
exec /usr/local/bin/wish "$0" ${1+"$@"}

#-------------------------------------------------#
# what: regular expression tester
# author: Ricardo Victor Guiman II
# icons from famfamfam.com
#-------------------------------------------------#

# use your own dir
lappend ::auto_path "/Users/rvguiman/Documents/Dev Folder/tcl/lib/famfamfam-master"

package require famfamfam
package require famfamfam::silk
package require BWidget

namespace eval RegCheck {

    variable regStr ""
    variable multilineSw 0

    proc checkNow { } {
        variable regStr
        variable multilineSw
        puts $regStr
        set allTxt [.txtarea get 1.0 end]
        .txtarea2 configure -state normal
        if { $multilineSw } {
            set lineCtr 0
            set matchSw 0
            set lineLs [list]
            foreach curLine $allTxt {
                #puts "\@$lineCtr:$curLine"
                set regRes [regexp $regStr $curLine]
                if { $regRes == 1 } {
                    lappend lineLs $curLine
                    set matchSw 1
                }
                incr lineCtr
            }
            set matchStr [join $lineLs "\n"]
            .txtarea2 delete 1.0 end
            if { $matchSw } {
                .txtarea2 insert 1.0 $matchStr
                .labmat configure -text "Matched word/s line/s: true" -fg darkgreen
            } else {
                .labmat configure -text "Matched word/s line/s: false" -fg red
            }
        } else {
            set regRes [regexp -all -inline $regStr $allTxt]
            .txtarea2 delete 1.0 end
            if { [llength $regRes] >= 1 } {
                set matchStr [join $regRes " "]
                .txtarea2 insert 1.0 $matchStr
                .labmat configure -text "Matched word/s line/s: true" -fg darkgreen
            } else {
                .labmat configure -text "Matched word/s line/s: false" -fg red
            }
        }
        .txtarea2 configure -state disabled 
    }
    
    proc iniGui { } {
        variable regStr
        variable multilineSw
        set icon [::famfamfam::silk get eye]
        wm iconphoto . -default $icon 
        wm title . "TCL regular expression tester"
        wm geometry . 400x400
        set iconReg [::famfamfam::silk get script_code]
        label .labstr -text "Reg Exp (do not enclose \{\})" -image $iconReg -compound left
        entry .entstr -bg white -textvariable [namespace which -variable regStr]
        set iconGlass [::famfamfam::silk get zoom]
        button .buttchk -text "Check" -command [namespace which -command checkNow] -image $iconGlass -compound left
        radiobutton .r1 -text "all lines (-all -inline)" -variable [namespace which -variable multilineSw] -value 0
        radiobutton .r2 -text "per line" -variable [namespace which -variable multilineSw] -value 1

        set iconSamStr [::famfamfam::silk get page_white_text]
        label .labtxt -text "Sample String" -image $iconSamStr -compound left
        set sw1 [::ScrolledWindow .uparea]
        set tx1 [text .txtarea -bg white]
        $sw1 setwidget $tx1
        
        set iconMatStr [::famfamfam::silk get control_equalizer_blue]
        label .labmat -text "Matched word/s line/s" -image $iconMatStr -compound left
        set sw2 [::ScrolledWindow .darea]
        set tx2 [text .txtarea2 -bg gray90 -state disabled]
        $sw2 setwidget $tx2
        
        grid .labstr -row 0 -column 0 -sticky w
        grid .entstr -row 1 -column 0 -columnspan 2 -sticky ew
        grid .buttchk -row 1 -column 2
        grid .r1 -row 2 -sticky w
        grid .r2 -row 3 -sticky w
        grid .labtxt -row 4 -sticky w
        grid .uparea -row 5 -columnspan 3 -sticky nesw
        grid .labmat -row 6 -sticky w
        grid .darea -row 7 -columnspan 3 -sticky nesw
        grid columnconfigure . 1 -weight 1
        grid rowconfigure . 5 -weight 1
        grid rowconfigure . 7 -weight 1
    }
}

RegCheck::iniGui
