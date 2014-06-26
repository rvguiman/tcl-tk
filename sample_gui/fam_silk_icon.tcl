#!/bin/sh
# next line starts tclsh
exec /usr/local/bin/wish "$0" ${1+"$@"}

#-------------------------------------------------------------------#
# what: sample using famfamfam icons and package from famfamfam.com
# author: ricardo
#-------------------------------------------------------------------#

lappend ::auto_path "/Users/rvguiman/Documents/Dev Folder/tcl/lib/famfamfam-master"

package require famfamfam
package require famfamfam::silk

proc iniGui { } {
  #get image icon, get image name from "http://famfamfam.com/lab/icons/silk/previews/index_abc.png"
  set exitIcon [::famfamfam::silk get door_out]
  button .buttQuit -text "Quit" -command exit -image $exitIcon -compound left
  pack .buttQuit
}

iniGui
