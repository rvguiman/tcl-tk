#---------------------------------- CSS Color Editor ----------------------------------#
# Author: Ricardo Victor Guiman II
# What: Auto seacrh and display all defined colors on a css file.
#       Split view of the original color and -replace by color- for earsier comparison.
#--------------------------------------------------------------------------------------#

package require Tk

#Global Vars
set colorList [list]
set colorList2 [list]
set cssFile ""
set cssRepCol ""
set data ""

proc remElemListByIndex { ind tmpLs } {
    if { $ind == 0 } {
        set newLs [lrange $tmpLs 1 end]
    } elseif { [llength $tmpLs] == [expr $ind+1] } {
        set newLs [lrange $tmpLs 0 end-1]
    } else {
        set newLs1 [lrange $tmpLs 0 [expr $ind-1]]
        set newLs2 [lrange $tmpLs [expr $ind+1] end]
        set newLs [concat $newLs1 $newLs2]
    }
    return $newLs
}

proc openCss { filePath } {
    global colorList colorList2 lf data
    set colorList [list]
    set fileHan [open $filePath r]
    set data [read $fileHan]
    #while { [gets $fileHan line] >= 0 } { }
    foreach line [split $data "\n"] {
        if { [regexp {color} $line] == 1 } {
            set semcolist [split $line ";"]
            foreach curSem $semcolist {
                if { [regexp {color} $curSem] == 1 } {
                    set csscol [string trim [lindex [split $curSem ":"] 1]]
                    set csscol [lindex [split $csscol " "] 0]
                    lappend colorList $csscol
                }
            }
        }
    }
    close $fileHan
    set ind 0
    set colorList [lsort -unique $colorList]
    set tmpList $colorList
    foreach curColor $tmpList {
        catch { $lf.lsb itemconfigure $ind -background $curColor -selectbackground $curColor } outRes
        if { $outRes != "" } {
            set colorList [remElemListByIndex $ind $colorList] 
        } else {
            incr ind
        }
    }
    set ind 0
    set colorList2 $colorList
    foreach curColor2 $colorList2 {
        $lf.lsb2 itemconfigure $ind -background $curColor2 -selectbackground $curColor2
        incr ind
    }
}

proc gFileDirSelector { { type "file" } } {
    global cssFile
	if { $type ne "dir" } {
		set types {
    			{{cssfiles}       {.css}    TEXT}
    			{{all files}        *           }
				}
		set filename [tk_getOpenFile -filetypes $types]
		if {$filename ne ""} {
    		puts "file selected -> $filename"
            set cssFile $filename
            openCss $filename
			return $filename
		} else {
			puts "file selection cancelled"
			return 0
		}
    } 
}

proc chCol { } {
    global lf lft colorList2 cssRepCol
    set pickCol [tk_chooseColor]
    if { $pickCol != "" } {
        $lft.butttest configure -bg $pickCol -text $pickCol
        set cssRepCol $pickCol
        if { [$lf.lsb2 curselection] == "" } {
            tk_messageBox -message "Please select an item on Replace By column" -icon error -type ok
        } else {
            set colorList2 [lreplace $colorList2 [$lf.lsb2 index active] [$lf.lsb2 index active] $pickCol]
            $lf.lsb2 itemconfigure active -background $pickCol -selectbackground $pickCol
        }
    }
}

proc sScr { scr args } {
    $scr set {*}$args
    {*}[$scr cget -command] moveto [lindex [$scr get] 0]
}

proc syncScr { widgets args } {
    foreach curWidget $widgets { 
        $curWidget {*}$args
    }
}

proc setColor { } {
    global lf lft cssRepCol colorList2
    if { $cssRepCol != "" } {
        $lft.butttest configure -bg $cssRepCol -text $cssRepCol
        if { [$lf.lsb2 curselection] == "" } {
            tk_messageBox -message "Please select an item on Replace By column" -icon error -type ok
        } else {
            set colorList2 [lreplace $colorList2 [$lf.lsb2 index active] [$lf.lsb2 index active] $cssRepCol]
            $lf.lsb2 itemconfigure active -background $cssRepCol -selectbackground $cssRepCol
        }
    }
}

proc saveAs { } {
        global colorList colorList2 data
		set types {
    			{{cssfiles}       {.css}    TEXT}
    			{{all files}        *           }
				}
		set filename [tk_getSaveFile -filetypes $types]
		if {$filename ne ""} {
    		puts "file selected -> $filename"
            set ctr 0
            foreach curColor $colorList {
                if { $curColor != [lindex $colorList2 $ctr] } {
                    puts "replace here"
                    regsub -all $curColor $data [lindex $colorList2 $ctr] data
                }
                incr ctr
            }
            set newCssHan [open $filename w]
            puts $newCssHan $data
            close $newCssHan
			return $filename
		} else {
			puts "file selection cancelled"
			return 0
		}
}

proc onGui { } {
    global cssFile colorList colorList2 lf lft cssRepCol
    set padxv 5
    set padyv 5
    wm title . "CSS COLOR TOOL"
    wm geometry . 400x500

    #Menu
    menu .men
    . config -menu .men
    set mFile [menu .men.file -tearoff 0]
    .men add cascade -label "File" -underline 0 -menu $mFile
    $mFile add cascade -label "Load Css" -underline 0 -command gFileDirSelector
    $mFile add cascade -label "Save As" -underline 0 -command saveAs
    $mFile add cascade -label "Exit" -underline 0 -command exit

    set lff [labelframe .lff -text "CSS FILE" -padx $padxv -pady $padyv] 
	  label $lff.labcss -text "Path:"
	  entry $lff.entcss -textvariable cssFile
	  button $lff.buttcss -text "Browse" -command gFileDirSelector

    set lft [labelframe .lft -text "TOOLS" -padx $padxv -pady $padyv]
    label $lft.labrep -text "Color Code:"
    entry $lft.entrep -textvariable cssRepCol
	  button $lft.buttrep -text "<- SET ->" -command setColor
    button $lft.butttest -text "Color Picker" -command chCol

    set lf [labelframe .lf -text "CSS COLORS" -padx $padxv -pady $padyv]
    label $lf.labor -text "Original"
    label $lf.labrep -text "Replace By"
    listbox $lf.lsb -listvariable colorList
    listbox $lf.lsb2 -listvariable colorList2
    scrollbar $lf.sby -command [list syncScr [list $lf.lsb $lf.lsb2] yview]
    $lf.lsb configure -yscrollcommand [list sScr $lf.sby]
    $lf.lsb2 configure -yscrollcommand [list sScr $lf.sby]

    grid $lff -sticky nesw -padx $padxv -pady $padyv
    grid $lff.labcss -row 0 -column 0
    grid $lff.entcss -row 0 -column 1 -sticky ew -padx $padxv
    grid $lff.buttcss -row 0 -column 2

    grid $lft -row 1 -sticky nesw -padx $padxv -pady $padyv
    grid $lft.labrep -row 0 -column 0
    grid $lft.entrep -row 0 -column 1 -sticky ew -padx $padxv
    grid $lft.buttrep -row 0 -column 2
    grid $lft.butttest -row 0 -column 3 -sticky nesw -padx $padxv

    grid $lf -sticky nesw -padx $padxv -pady $padyv
    grid $lf.labor -row 0 -column 0 -sticky w
    grid $lf.labrep -row 0 -column 1 -sticky w
	 grid $lf.lsb -row 1 -column 0 -sticky nesw
    grid $lf.lsb2 -row 1 -column 1 -sticky nesw
    grid $lf.sby -row 1 -column 2 -sticky ns
    
    grid columnconfigure . 0 -weight 1
    grid rowconfigure . 2 -weight 1
    grid columnconfigure $lff 1 -weight 1
    grid columnconfigure $lft 1 -weight 1
    grid columnconfigure $lf 1 -weight 1
	grid rowconfigure $lf 1 -weight 1
}

onGui
