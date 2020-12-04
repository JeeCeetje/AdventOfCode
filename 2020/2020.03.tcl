# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set height          [llength $input]
set widthModulus    [string length [lindex $input 0]]

proc slide {incX incY} {
    set x 0
    set y 0
    set nrOfTrees 0
    
    while {$y < $::height} {
        set y   [expr  $y + $incY]
        set x   [expr ($x + $incX) % $::widthModulus]
        set loc [string index [lindex $::input $y] $x]
        if {$loc == "#"} {
            incr nrOfTrees
        }
    }
    
    return $nrOfTrees
}

puts [slide 3 1]


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b

set     slopes ""
lappend slopes [slide 1 1]
lappend slopes [slide 3 1]
lappend slopes [slide 5 1]
lappend slopes [slide 7 1]
lappend slopes [slide 1 2]

set result 1
foreach s $slopes {
    set result [expr $result*$s]
}
puts "$slopes => $result"


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.03:a
# 289
# 2020.03:b
# 84 289 89 71 36 => 5522401584


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
