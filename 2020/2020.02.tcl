# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set nrOfCorrectPass 0
foreach i $input {
    regexp {(\d+)-(\d+)\s+(\w):\s+(\w+)} $i all min max char pass
    set cnt [regexp -all $char $pass]
    if {($cnt >= $min) && ($cnt <= $max)} {
        incr nrOfCorrectPass
    }
}
puts $nrOfCorrectPass


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b

set nrOfCorrectPass 0
foreach i $input {
    regexp {(\d+)-(\d+)\s+(\w):\s+(\w+)} $i all locA locB char pass
    set locA [expr $locA - 1]
    set locB [expr $locB - 1]
    set a [string range $pass $locA $locA]
    set b [string range $pass $locB $locB]
    if  {(($a == $char) && ($b != $char)) ||
         (($a != $char) && ($b == $char))} {
        incr nrOfCorrectPass
    }
}
puts $nrOfCorrectPass


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.02:a
# 622
# 2020.02:b
# 263


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
