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




# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------




# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
