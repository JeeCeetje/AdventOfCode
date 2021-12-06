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
set resultA 0

# Read input and find horizontal and vertical lines only
foreach i $input {
    regexp {(\d+),(\d+) -> (\d+),(\d+)} $i all x1 y1 x2 y2
    if {$x1 == $x2} {
        if {$y1 > $y2} {
            set y0 $y1
            set y1 $y2
            set y2 $y0
        }
        for {} {$y1 <= $y2} {incr y1} {
            incr field($x1,$y1)
            if {$field($x1,$y1) == 2} {
                incr resultA
            }
        }
    } elseif {$y1 == $y2} {
        if {$x1 > $x2} {
            set x0 $x1
            set x1 $x2
            set x2 $x0
        }
        for {} {$x1 <= $x2} {incr x1} {
            incr field($x1,$y1)
            if {$field($x1,$y1) == 2} {
                incr resultA
            }
        }
    }
}

puts $resultA



# --------------------------------------------------------------------------------
# Question B
# --------------------------------------------------------------------------------
puts $puzzleNr:b
set resultB $resultA

# Read input and find diagonal lines only
foreach i $input {
    regexp {(\d+),(\d+) -> (\d+),(\d+)} $i all x1 y1 x2 y2
    if {($x1 != $x2) && ($y1 != $y2)} {
        if {$x1 > $x2} {
            set x0 $x1; set y0 $y1
            set x1 $x2; set y1 $y2
            set x2 $x0; set y2 $y0
        }
        set yIncr 1
        if {$y1 > $y2} {
            set yIncr -1
        }
        for {} {$x1 <= $x2} {incr x1; incr y1 $yIncr} {
            incr field($x1,$y1)
            if {$field($x1,$y1) == 2} {
                incr resultB
            }
        }
    }
}

puts $resultB



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2021.05:a
# 7674
# 2021.05:b
# 20898



# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------


