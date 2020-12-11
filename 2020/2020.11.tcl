# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a


proc createInitialPlan {} {
    global input
    global plan
    set y 0
    foreach i $input {
        set x 0
        foreach j [split [regsub -all "L" $i 0] ""] {   ;# Save the seating plan in an matrix
            set plan($x,$y) $j
            incr x
        }
        incr y
    }

    set plan(x) [string length [lindex $input 0]]
    set plan(y) $y
}


proc printSeatingPlan {} {                              ;# Print for visualisation
    global plan
    for {set y 0} {$y < $plan(y)} {incr y} {
        for {set x 0} {$x < $plan(x)} {incr x} {
            puts -nonewline $plan($x,$y)
        }
        puts ""
    }
}


proc countOccupied {} {                                 ;# Count number of occupied seats
    global plan
    set occupied 0
    for {set y 0} {$y < $plan(y)} {incr y} {
        for {set x 0} {$x < $plan(x)} {incr x} {
            if {$plan($x,$y) == 1} {
                incr occupied
            }
        }
    }
    return $occupied
}


proc checkAdjacentOccupied {x y} {                      ;# Check occupation of adjacent seats
    global plan
    set occupied 0
    for {set b -1} {$b < 2} {incr b} {                  ;# Create kernel
        for {set a -1} {$a < 2} {incr a} {
            if {$a == 0 && $b == 0} {                   ;# Skip own seat
                continue
            }
            set X [expr $x + $a]
            set Y [expr $y + $b]
            if {$X > -1       &&
                $X < $plan(x) &&
                $Y > -1       &&
                $Y < $plan(y) &&
                $plan($X,$Y) == 1} {                    ;# Check boundary conditions and location
                incr occupied
            }
        }
    }
    return $occupied
}


proc runRules {occupationFunction occupationLimit} {    ;# Run the rules a single time
    global plan
    set changed 0
    for {set y 0} {$y < $plan(y)} {incr y} {
        for {set x 0} {$x < $plan(x)} {incr x} {
            set occupation($x,$y) [$occupationFunction $x $y]   ;# Create an occupation plan before changing the seating plan,
        }                                                       ;# otherwise, the changes affect the next seat already.
    }
    for {set y 0} {$y < $plan(y)} {incr y} {
        for {set x 0} {$x < $plan(x)} {incr x} {
            if {$plan($x,$y) == 0} {                    ;# Rule 1 : empty to seated
                if {$occupation($x,$y) == 0} {
                    set plan($x,$y) 1
                    set changed 1
                }
            } elseif {$plan($x,$y) == 1} {              ;# Rule 2 : seated to empty
                if {$occupation($x,$y) >= $occupationLimit} {
                    set plan($x,$y) 0
                    set changed 1
                }
            }
        }
    }
    return $changed
}


createInitialPlan
puts [time {
    while {[runRules checkAdjacentOccupied 4]} {}
    puts [countOccupied]
}]


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b


proc checkSeenOccupied {x y} {                          ;# Check occupation of seen seats
    global plan
    set occupied 0
    for {set dir 0} {$dir < 8} {incr dir} {             ;# Check the eight directions
        set seen 0
        for {set c 1} {$c < $plan(y) && !$seen} {incr c} {
            switch $dir {
                0 { # North
                    set X $x
                    set Y [expr $y - $c]
                }
                1 { # North-east
                    set X [expr $x + $c]
                    set Y [expr $y - $c]
                }
                2 { # East
                    set X [expr $x + $c]
                    set Y $y
                }
                3 { # South-east
                    set X [expr $x + $c]
                    set Y [expr $y + $c]
                }
                4 { # South
                    set X $x
                    set Y [expr $y + $c]
                }
                5 { # South-west
                    set X [expr $x - $c]
                    set Y [expr $y + $c]
                }
                6 { # West
                    set X [expr $x - $c]
                    set Y $y
                }
                7 { # North-west
                    set X [expr $x - $c]
                    set Y [expr $y - $c]
                }
            }
            if {$X > -1       &&
                $X < $plan(x) &&
                $Y > -1       &&
                $Y < $plan(y) } {                       ;# Check boundary conditions
                if {$plan($X,$Y) != "."} {              ;# Look over floor spaces
                    incr occupied $plan($X,$Y)
                    set seen 1
                }
            } else {
                set seen 1                              ;# If we reached the border, stop searching in that direction
            }
        }
    }
    return $occupied
}


createInitialPlan                                       ;# Reset initial plan, otherwise we continue on the plan of question 1 :-)
puts [time {
    while {[runRules checkSeenOccupied 5]} {}
    puts [countOccupied]
}]


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.11:a
# 2329
# 22479398 microseconds per iteration
# 2020.11:b
# 2138
# 21353928 microseconds per iteration


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------

# Both calculations take around 22 seconds to complete. Probably there is a faster way?
