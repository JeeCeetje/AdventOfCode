# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set spoken(turn) 0


proc speak {number} {
    global spoken
    incr spoken(turn)
    # puts "Turn $spoken(turn) : $number"
    if {[info exists spoken($number)]} {
        set prevTurn $spoken($number)
        set spoken($number) $spoken(turn)
        return [expr $spoken(turn)-$prevTurn]
    } else {
        set spoken($number) $spoken(turn)
        return 0
    }
}


foreach i [split $input ","] {
    set lastSpoken [speak $i]
}

while {$spoken(turn) < [expr 2020 - 1]} {
    set lastSpoken [speak $lastSpoken]
}

puts $lastSpoken


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.15:a
# 249


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
