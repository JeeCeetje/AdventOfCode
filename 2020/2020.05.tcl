# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

proc getDecimalValue {str {zeroChar "F"} {oneChar "B"}} {
    set str [regsub -all $zeroChar $str 0]
    set str [regsub -all $oneChar  $str 1]
    return [expr 0b$str]
}

set ids ""
foreach i $input {
    set row [getDecimalValue [string range $i 0 6] "F" "B"]
    set col [getDecimalValue [string range $i 7 9] "L" "R"]
    lappend ids [expr $row *8 + $col]
}
set ids [lsort -integer -increasing $ids]
puts [lindex $ids end]



# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b

for {set i 0} {$i < [expr [llength $ids] - 1]} {incr i} {
    set idA [lindex $ids $i]
    set idB [lindex $ids [expr $i + 1]]
    set idBexpected [expr $idA + 1]
    if {$idB != $idBexpected} {
        puts $idBexpected
    }
}



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.05:a
# 980
# 2020.05:b
# 607


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------

# The tricky thing is that we don't need to keep track of upcounting and downcounting.
# Just parse the seat numbers as a binary value (by replacing the chars with 0 and 1).

# The code of question 1 was slightly modified after question 2 was available.
# I didn't keep a list of the results, just kept a maximum ID on the go. This was changed
# to keeping a list, sorting it and taking out the last element. This list was then used in
# question 2.

# For question 2, as we know that the front seats aren't available but that the seat ID
# before/after yours is present in the list. So the first ID and last ID in the list is not
# checked.
