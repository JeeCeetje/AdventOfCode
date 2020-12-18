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


proc calculate {expressionList {index 0}} {
    set result   0
    set operator +
    for {} {$index < [llength $expressionList]} {incr index} {
        set element [lindex $expressionList $index]
        switch $element {
            "(" {
                set subresult [calculate $expressionList [expr $index+1]]
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

set precedenceOrder ""
lappend precedenceOrder {(\()(\d+)(\))}                     ;# Integer in brackets => supercool by putting e.g. (5) in expr, it will return 5
lappend precedenceOrder {\((\d+)(\+)(\d+)\)}                ;# Sum in brackets => supercool by matching the + as a char and putting it in a var, we can use it in expr
lappend precedenceOrder {\((\d+)(\*)(\d+)\)}                ;# Mult in brackets
lappend precedenceOrder {(\d+)(\+)(\d+)}                    ;# Sum outside brackets
lappend precedenceOrder {(\d+)(\*)(\d+)}                    ;# Mult outside brackets


proc calculateAdvanced {expressionString} {                 ;# Do checks on multiple digits as the subresult will be larger than single digits
    for {set i 0} {$i < [llength $::precedenceOrder]} {} {
        if {[regexp [lindex $::precedenceOrder $i] $expressionString all a op b]} {
            regsub [lindex $::precedenceOrder $i] $expressionString [expr $a $op $b] expressionString
            set i 0
            # puts $expressionString
        } else {
            incr i
        }
    }
    # puts ""
    return $expressionString
}


set sum 0
foreach i $input {
    incr sum [calculateAdvanced $i]
}
puts $sum


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.18:a
# 654686398176


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
