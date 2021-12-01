# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]
# set input       [split [read [open $puzzleNr\_example.txt r]] \n]
set len         [llength $input]



# --------------------------------------------------------------------------------
# Question A
# --------------------------------------------------------------------------------
puts $puzzleNr:a
set resultA 0

for {set i 0} {$i < [expr $len-1]} {incr i} {
    if {[lindex $input $i] < [lindex $input [expr $i+1]]} {
        incr resultA
    }
}

puts $resultA



# --------------------------------------------------------------------------------
# Question B
# --------------------------------------------------------------------------------
puts $puzzleNr:b
set resultB 0

set prev 0
for {set i 0} {$i < [expr $len-3]} {incr i} {
    set sum [expr [lindex $input $i] + [lindex $input [expr $i+1]] + [lindex $input [expr $i+2]]]
    if {$sum > $prev} {
        incr resultB
    }
    set prev $sum
}

puts $resultB



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2021.01:a
# 1709
# 2021.01:b
# 1761



# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------


