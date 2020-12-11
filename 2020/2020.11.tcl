# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set y 0
foreach i $input {
    set x 0
    foreach j [split [regsub -all "L" $i 0] ""] {       ;# Save the seating plan in an matrix
        set plan($x,$y) $j
        incr x
    }
    incr y
}

set plan(x) [string length [lindex $input 0]]
set plan(y) $y


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


proc runRules {} {                                      ;# Run the rules a single time
    global plan
    set changed 0
    for {set y 0} {$y < $plan(y)} {incr y} {
        for {set x 0} {$x < $plan(x)} {incr x} {
            set occupation($x,$y) [checkAdjacentOccupied $x $y]
        }
    }
    for {set y 0} {$y < $plan(y)} {incr y} {
        for {set x 0} {$x < $plan(x)} {incr x} {
            if {$plan($x,$y) == 0} {
                if {$occupation($x,$y) == 0} {
                    set plan($x,$y) 1
                    set changed 1
                }
            } elseif {$plan($x,$y) == 1} {
                if {$occupation($x,$y) >= 4} {
                    set plan($x,$y) 0
                    set changed 1
                }
            }
        }
    }
    return $changed
}


while {[runRules]} {}
puts [countOccupied]


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b




# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.11:a
# 2329


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
