#!/bin/sh
# next line starts wish \
exec /bin/wish "$0" ${1+"$@"}

#---------------------------------------------------
# what: sample snit widget object
# author: ricardo
#---------------------------------------------------

# lappend ::auto_path /ActiveTcl8.6.0.0/lib/   - specify package path

package require tablelist 5.1
package require snit

snit::widget SenderWidget {
    
    option -width 0
    option -height 0
    
    method insertData { dataList } {
        #datalist format [list [list "" "" ""] [list "" "" ""] ]
        .tab insertchildlist root end $dataList
        .tab configure -height 0
        .tab configure -width 0
    }
    
    constructor { args } {
        $self configurelist $args
        set fr [labelframe $win.f -text "Lower Frame"]
        tablelist::tablelist .tab -showseparators 1 -columns { 0 "file" 0 "path" 0 "size" } \
            -stretch all -width [$self cget -width] -height [$self cget -height]
        
        grid .tab -in $fr -row 0 -column 0 -sticky nesw
        grid $fr -sticky nesw
        
        grid columnconfigure $fr 0 -weight 1
        grid rowconfigure $fr 0 -weight 1
        grid columnconfigure $win 0 -weight 1
        grid rowconfigure $win 0 -weight 1
    }
    
}

labelframe .frTop -text "top frame"
::SenderWidget .senderWgt -width 0 -height 0

grid .senderWgt -in .frTop -row 0 -column 0 -sticky nesw
grid .frTop -sticky nesw

grid columnconfigure .frTop 0 -weight 1
grid rowconfigure .frTop 0 -weight 1
grid columnconfigure . 0 -weight 1
grid rowconfigure . 0 -weight 1

.senderWgt insertData [list [list "filename" "/dir/file" "4kb"] ]
.senderWgt insertData [list [list "filename" "/dir/test/sdfsdfsdf/sdfsdfsdfsdf/sdfsdfsdf/longdir" "4kb"] ]
