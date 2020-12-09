# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set preambleLength  25
set streamLength    [llength $input]

for {set i $preambleLength} {$i < $streamLength} {incr i} {
    set preamble [lsort [lrange $input [expr $i-$preambleLength] [expr $i-1]]]      ;# This is the sorted preamble list
    set value    [lindex $input $i]                                                 ;# This is the value that should be verified
    set verified 0
    for {set a 0} {$a < [expr $preambleLength-1] && !$verified} {incr a} {          ;# Run from the first element to the second last or until verified
        for {set b [expr $a+1]} {$b < $preambleLength && !$verified} {incr b} {     ;# Run from the second element to the last or until verified
            set res [expr [lindex $preamble $a] + [lindex $preamble $b]]
            if {$res == $value} {                                                   ;# If the result matches the value, the value is verified
                set verified 1
            } elseif {$res > $value} {                                              ;# Else if the result is greater than the value, stop the inner loop as the results will increase
                continue
            }
        }
    }
    if {!$verified} {                                                               ;# If we didn't verify the value, we have a faulty one!
        puts $value
        break
    }
}


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b




# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.09:a
# 1212510616


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------

# How to do this more efficient?
# Is sorting a good idea? Is the combination sorting + extra check {$res > $value} faster?
