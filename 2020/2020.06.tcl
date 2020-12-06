# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set data        [read [open $puzzleNr\_input.txt r]]


# Split data by finding as many chars until more than one newline is found
set splitted [regexp -inline -line -all {(.+\n?)+} $data]

# Due to how the tcl regexp inline function works, keep only the even results
set input ""
for {set i 0} {$i < [llength $splitted]} {incr i 2} {
    lappend input [lindex $splitted $i]
}


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set totalCnt 0
foreach i $input {
    foreach char [split abcdefghijklmnopqrstuvwxyz ""] {
        incr totalCnt [regexp $char $i]
    }
}
puts $totalCnt


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b

set totalCnt 0
foreach i $input {
    set nrOfPeopleInGroup [llength [split [string trim $i]]]
    foreach char [split abcdefghijklmnopqrstuvwxyz ""] {
        if {[regexp -all $char $i] == $nrOfPeopleInGroup} {
            incr totalCnt
        }
    }
}
puts $totalCnt


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.06:a
# 6530
# 2020.06:b
# 3323


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------

# Used the split on double newline regex from 2020.04.
# However trim before counting lines (due to the extra line).

# As there is no a to z loop in TCL, create a string with all the chars and split it
# with nothing ("") to have a list with all separate chars. List could have been created
# manually as well of course.
