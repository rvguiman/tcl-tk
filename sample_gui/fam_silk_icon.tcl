#!/bin/sh
# next line starts tclsh
exec /bin/wish "$0" ${1+"$@"}

#-------------------------------------------------------------------#
# what: sample using famfamfam icons and package from famfamfam.com
# author: ricardo
#-------------------------------------------------------------------#

# append your auto path with the package directory
# lappand ::auto_path /tcl/lib/your_dir/famfamfam1/
# lappand ::auto_path /tcl/lib/your_dir/famfamfam_silk1/

package require famfamfam
package require famfamfam::silk

proc iniGui { } {
  #get image icon, get image name from "http://famfamfam.com/lab/icons/silk/previews/index_abc.png"
  set exitIcon [::famfamfam::silk get door_out]
  button .buttQuit -text "Quit" -command exit -image $exitIcon -compound left
  pack .buttQuit
}

iniGui
