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

foreach i $input {
    set x 0
    foreach j [split $i ""] {
        incr b($x) $j
        incr x
    }
}

set gamma   ""
set epsilon ""
for {set j 0} {$j < $x} {incr j} {
    if {$b($j) > [expr $len/2]} {
        append gamma   1
        append epsilon 0
    } else {
        append gamma   0
        append epsilon 1
    }
}

puts [expr 0b$gamma * 0b$epsilon]



# --------------------------------------------------------------------------------
# Question B
# --------------------------------------------------------------------------------
puts $puzzleNr:b

set oxygen  ""
set co2     ""

proc getRating {argList {argMost 0} {intPatt "0*"}} {
    set argLen [llength $argList]
    if {$argLen == 1} {
        return [lindex $argList 0]
    } else {
        set zeroList {}
        set oneList  {}
        foreach i $argList {
            if {[string match $intPatt $i]} {
                lappend zeroList $i
            } else {
                lappend oneList $i
            }
        }
        set zeroLen [llength $zeroList]
        set oneLen  [llength $oneList]
        # puts "$argList\n$zeroLen : $zeroList\n$oneLen : $oneList\n"
        if { (($zeroLen <= $oneLen) && ($argMost == 0)) || (($zeroLen > $oneLen) && ($argMost == 1)) } {
            return [getRating $zeroList $argMost ?$intPatt]
        } else {
            return [getRating $oneList $argMost ?$intPatt]
        }
    }
}

set oxygen [getRating $input 1]
set co2    [getRating $input 0]

puts [expr 0b$oxygen * 0b$co2]



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2021.03:a
# 3985686
# 2021.03:b
# 2555739



# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------


