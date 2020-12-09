# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]
# set input       [split [read [open $puzzleNr\_example.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set preambleLength  25
set streamLength    [llength $input]

set incorrectVal    ""
set indexIncorVal   ""

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
        set incorrectVal $value
        set indexIncorVal $i
        break
    }
}

puts $incorrectVal


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b

set found 0
set contiguousSet ""

for {set i [expr $indexIncorVal-1]} {$i > 0 && !$found} {incr i -1} {               ;# Run back from the index of the found result
    set sum 0
    set j   $i
    while {$sum < $incorrectVal} {                                                  ;# Add the previous indexed values until we exceed the value...
        incr sum [lindex $input $j]
        if {$sum == $incorrectVal} {                                                ;# ... or we hit it spot on!
            set found 1
            set contiguousSet [lrange $input $j $i]
        }
        incr j -1
    }
}

set sorted [lsort -integer $contiguousSet]
puts [expr [lindex $sorted 0] + [lindex $sorted end]]



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.09:a
# 1212510616
# 2020.09:b
# 171265123


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------

# How to do this more efficient?
# Is sorting a good idea? Is the combination sorting + extra check {$res > $value} faster?
