# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [read [open $puzzleNr\_input.txt r]]
# set input       [read [open $puzzleNr\_example.txt r]]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

regsub -all -line { } $input "" input                       ;# Remove all spaces
set input [split $input \n]


proc calculate {expression {index 0}} {
    set result   0
    set operator +
    for {} {$index < [llength $expression]} {incr index} {
        set element [lindex $expression $index]
        switch $element {
            "(" {
                set subresult [calculate $expression [expr $index+1]]
                set result [expr $result $operator [lindex $subresult 0]]
                set index [lindex $subresult 1]
            }
            ")" {return "$result $index"}
            "+" {set operator +}
            "*" {set operator *}
            default {
                if {[string is digit -strict $element]} {
                    set result [expr $result $operator $element]
                } else {
                    puts "Parsing error: $element"
                }
            }
        }
    }
    return "$result $index"
}


set sum 0
foreach i $input {
    set result [calculate [split $i ""]]                    ;# Split every element, input contains only single digit numbers
    incr sum [lindex $result 0]
}
puts $sum


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b




# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.18:a
# 654686398176


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
