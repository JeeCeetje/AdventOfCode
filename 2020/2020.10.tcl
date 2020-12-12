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

set sortedInput [linsert $sortedInput 0 0]          ;# Add the outlet in front of the list

set diffInput ""                                    ;# Create a list of the jolt jumps instead of the absolute values
for {set i 0} {$i < [expr [llength $sortedInput]]} {incr i} {
    lappend diffInput [expr [lindex $sortedInput [expr $i + 1]] - [lindex $sortedInput $i]]
}

set runLengthInput ""                               ;# Create a list of the run lengths of single jolt jumps (we're not interested in the 3 jolt jumps, as they must stay in the reordening)
set currRun 0
foreach i $diffInput {
    if {$i == 1} {
        incr currRun
    } elseif {$currRun > 0} {
        lappend runLengthInput [expr $currRun + 1]  ;# Add one because e.g. 3x 1 jolt jumps relate to 4 numbers
        set currRun 0
    }
}


proc getNumberOfCombinations {runLength} {
    set runLength [expr $runLength-2]               ;# The two outer adapters are connected to the 3 jolt jumps and would break a valid chain, so they must stay, don't use them in the permutations
    if {$runLength <= 0} {                          ;# If we have nothing left to play with...
        return 1                                    ;# then only a single combination is possible; the 'normal' nonpermuted one
    }
    set combinations ""                             ;# Represent the permuations as binary strings
    for {set i 0} {$i < [expr 2**$runLength]} {incr i} {
        lappend combinations [format %0[subst $runLength]b $i]
    }
    set validCombinations 0
    foreach c $combinations {
        if {![regexp {000} $c]} {                   ;# If the binary string contains at least 3 zeroes in a row, it is invalid
            incr validCombinations
        }
    }
    return $validCombinations
}


set nrOfCombinations 1
foreach j $runLengthInput {
    set nrOfCombinations [expr $nrOfCombinations * [getNumberOfCombinations $j]]
}
puts $nrOfCombinations


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.10:a
# 2244
# 2020.10:b
# 3947645370368


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
