#--------------------- g_tk_file_utility.tcl --------------------#
# what:   collection of file utility procedures with gui or tk for tcl
# author: Ricardo Victor Guiman II
#----------------------------------------------------------------#

#-------------------------- gFileDirSelector ---------------------------------------------------------------------------------------------#
# what:  	procedure for selecting a file or directory, run it using wish/tk
# arg:		optional arg type, valid values none/anything for file selection or "dir" if you want to choose directory instead of file
# return:	if type is file, return the full path of file or 0 if cancelled
#-----------------------------------------------------------------------------------------------------------------------------------------#

proc gFileDirSelector { { type "file" } } {
  if { $type ne "dir" } {
		  set types {
    			{{text files}       {.txt}    TEXT}
    			{{tcl scripts}      {.tcl}        }
    			{{all files}        *             }
				}
		  set filename [tk_getOpenFile -filetypes $types]
		  if {$filename ne ""} {
    			puts "file selected -> $filename"
			    return $filename
			    } else {
			    puts "file selection cancelled"
			    return 0
			    }
		  } else {
		  set dirSel [tk_chooseDirectory]
		  if {$dirSel ne ""} {
    			puts "dir selected -> $dirSel"
			    return $dirSel
			    } else {
			    puts "directory selection cancelled"
			    return 0
			    }
		  } 
	}
