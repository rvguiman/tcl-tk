#!/bin/sh
# next line starts wish \
exec /bin/wish "$0" ${1+"$@"}

#---------------------------------------------------
# what: sample snit widget object
# author: ricardo
#---------------------------------------------------

# lappend ::auto_path /ActiveTcl8.6.0.0/lib/   - specify package path
# lappend ::auto_path /famfam_path
# lappend ::auto_path /famfamsilk_path

proc calltest { } {
    puts "called test"
}

snit::widget SenderWidget {
    
    option -width 0
    option -height 0
    option -callback
    
    method setBindCell { } {
        bind [.tab bodytag] <Button-1> {
        foreach {tablelist::W tablelist::x tablelist::y} \
            [tablelist::convEventFields %W %x %y] {}
            puts "clicked on cell [.tab containingcell $tablelist::x $tablelist::y]"
        }
    }
    
    method setBindRow { } {
        bind [.tab bodytag] <Button-3> {
        foreach {tablelist::W tablelist::x tablelist::y} \
            [tablelist::convEventFields %W %x %y] {}
            puts "clicked on row [.tab containing $tablelist::y]"
            .tab select clear 0 end
            .tab select set [list [.tab containing $tablelist::y] ]
            tk_popup .popMenu %X %Y
        }
    }
    
    method callCallback { } {
        puts "test"
        eval "::[$self cget -callback]"
    }
    
    method setIcon { fileName kIndex } {
        set pdfIcon [::famfamfam::silk get page_white_acrobat]
        set wordIcon [::famfamfam::silk get page_white_word]
        set excelIcon [::famfamfam::silk get page_white_excel]
        set unkIcon [::famfamfam::silk get help]
        if { [lindex [split $fileName "."] end ] == "pdf" } {
            .tab cellconfigure $kIndex,0 -image $pdfIcon
        } elseif { [lindex [split $fileName "."] end ] == "doc" } {
            .tab cellconfigure $kIndex,0 -image $wordIcon
        } elseif { [lindex [split $fileName "."] end ] == "xls" } {
            .tab cellconfigure $kIndex,0 -image $excelIcon
        } else {
            .tab cellconfigure $kIndex,0 -image $unkIcon
        }
        
        #.tab cellconfigure $k,0 -image $delIcon
    }
    
    method insertData { dataList } {
        #data table insert format [list [list "" "" ""] [list "" "" ""] ]
        
        foreach curList $dataList {
            set kIndex [.tab insertchildlist root end [list [concat [list ""] $curList] ] ]
            $self setIcon [lindex $curList 0] $kIndex
            .tab configure -height 0
            .tab configure -width 0
        }
    }
    
    method delData { } {
        puts "deleting data"
    }
    
    constructor { args } {
        $self configurelist $args
        set fr [labelframe $win.f -text "Lower Frame" -padx 5 -pady 5]
        tablelist::tablelist .tab -showseparators 1 -columns { 0 "type" 0 "file" 0 "path" 0 "size" } \
            -stretch all -width [$self cget -width] -height [$self cget -height] -selecttype row
        button .buttCallBack -text "callback" -command [list $self callCallback ]
        button .buttExit -text "Exit" -command exit
        
        grid .tab -in $fr -row 0 -column 0 -sticky nesw
        grid .buttCallBack -in $fr -row 1 -column 0 -sticky w
        grid .buttExit -in $fr -row 2 -column 0 -sticky w
        grid $fr -sticky nesw -padx 5 -pady 5
        
        grid columnconfigure $fr 0 -weight 1
        grid rowconfigure $fr 0 -weight 1
        grid columnconfigure $win 0 -weight 1
        grid rowconfigure $win 0 -weight 1
        
        #pop up menu
        set delIcon [::famfamfam::silk get bin]
        set cancelIcon [::famfamfam::silk get cancel]
        set addIcon [::famfamfam::silk get add]
        
        set pm [menu .popMenu -title "Options" -tearoff 0]
        $pm add command -label " delete file" -command [list $self delData] -image $delIcon -compound left
        $pm add command -label " add file" -command [list $self delData] -image $addIcon -compound left
        $pm add command -label " cancel" -image $cancelIcon -compound left
        
        # left click or right click binding sample
        $self setBindRow
        # for cell
        #$self setBindCell
    }
    
}

labelframe .frTop -text "top frame" -padx 5 -pady 5
::SenderWidget .senderWgt -width 0 -height 0 -callback calltest

grid .senderWgt -in .frTop -row 0 -column 0 -sticky nesw
grid .frTop -sticky nesw -padx 5 -pady 5

grid columnconfigure .frTop 0 -weight 1
grid rowconfigure .frTop 0 -weight 1
grid columnconfigure . 0 -weight 1
grid rowconfigure . 0 -weight 1

.senderWgt insertData [list [list "file1.pdf" "/dir/file" "4kb"] \
                      [list "file2.doc" "/dir/test/sdfsdfsdf/dfsdf/longdir" "4kb"] \
                      [list "file3.xls" "/dir/dfsdf/meddir" "4kb"] \
                      [list "file4.ppt" "/dir/dfsdf/meddir" "4kb"]]
