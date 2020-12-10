# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set joltDiff(1)          1   ;# Outlet
set joltDiff(2)          0
set joltDiff(3)          1   ;# Device
set joltDiff(invalid)    0

set sortedInput [lsort -integer $input]
for {set i 0} {$i < [expr [llength $sortedInput]-1]} {incr i} {
    switch [expr [lindex $sortedInput [expr $i + 1]] - [lindex $sortedInput $i]] {
        1       {incr joltDiff(1)}
        2       {incr joltDiff(2)}
        3       {incr joltDiff(3)}
        default {incr joltDiff(invalid)}
    }
}

puts [expr $joltDiff(1) * $joltDiff(3)]


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b




# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.10:a
# 2244


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
