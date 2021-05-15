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
lappend precedenceOrder {(\d+)(\+)(\d+)}                    ;# Sum
lappend precedenceOrder {(\d+)(\*)(\d+)}                    ;# Mult


proc calculateInner {expressionString} {                    ;# Do checks on multiple digits as the subresult will be larger than single digits
    for {set i 0} {$i < [llength $::precedenceOrder]} {incr i} {
        if {[regexp [lindex $::precedenceOrder $i] $expressionString all a op b]} {
            puts $expressionString
            regsub [lindex $::precedenceOrder $i] $expressionString [expr $a $op $b] expressionString
            puts $expressionString
            set i 0
        }
    }
    puts ""
    return $expressionString
}


# set nonIntegers         {\(|\)|\+|\*}
# set precedenceOrder ""
# # lappend precedenceOrder {\((\d+)(\+)(\d+)\)}                ;# Sum in brackets => supercool by matching the + as a char and putting it in a var, we can use it in expr
# lappend precedenceOrder {(\d+)(\+)(\d+)}                    ;# Sum outside brackets
# # lappend precedenceOrder {\((\d+)(\*)(\d+)\)}                ;# Mult in brackets
# lappend precedenceOrder {(\d+)(\*)(\d+)}                    ;# Mult outside brackets
# set brackets            {(\()(\d+)(\))}                     ;# Integer in brackets => supercool by putting e.g. (5) in expr, it will return 5


# proc calculateAdvanced {expressionString} {                 ;# Do checks on multiple digits as the subresult will be larger than single digits
    # while {[regexp $::nonIntegers $expressionString]} {     ;# As long as we have no result, keep looping
        # for {set i 0} {$i < [llength $::precedenceOrder]} {incr i} {    ;# Try to solve as much as possible without removing brackets
            # if {[regexp [lindex $::precedenceOrder $i] $expressionString all a op b]} {
                # regsub [lindex $::precedenceOrder $i] $expressionString [expr $a $op $b] expressionString
                # puts $expressionString
                # set i 0
            # }
        # }
        # while {[regexp $::brackets $expressionString all a op b]} {     ;# If all is exhausted, remove brackets around integers
            # regsub $::brackets $expressionString [expr $a $op $b] expressionString
            # puts $expressionString
        # }
    # }
    # puts ""
            # puts $expressionString
    # return $expressionString
# }

set bracketExpression {\((\d+(\+|\*)[\d\+\*]+)\)}           ;# This regex finds an inner bracket expression

proc calculateAdvanced {expressionString} {
    set result 0
    while {[regexp $::bracketExpression $expressionString all expression]} {        ;# Find inner expressions
        regsub $::bracketExpression $expressionString ([calculateInner $expression]) expressionString    ;# Mark that the result of the expression is back put in quotes
    }
    # while {[regexp $::bracketExpression $expressionString all expression]} {        # First handle inner expressions
    # }
    return $result
}


set sum 0
set j 0
foreach i $input {
    puts [incr j]
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
