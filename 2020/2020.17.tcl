# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
# set input       [read [open $puzzleNr\_input.txt r]]
set input       [read [open $puzzleNr\_example.txt r]]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set dimension [string first "\n" $input]                        ;# Find the index of the first newline, that is the dimension of the cube
regsub -all {\.} $input "0" input                               ;# Replace all inactive with zero (escape any character!)
regsub -all {\#} $input "1" input                               ;# Replace all active with 1 (escape tcl comment character!)
set input [split $input \n]


proc initializeCube {cycle} {                                   ;# Initialize an empty cube for this cycle
    set toHalfSize   [expr $::dimension/2 + $cycle + 1]         ;# Add extra per cycle for growing cube, add extra for easier neighbour calculation in the next cycle...
                                                                ;# ... if we go back a cycle, to get its state or neighbours state, it will exist
    set fromHalfSize [expr -1*$toHalfSize]                      ;# Coordinates are around 0,0,0 midpoint
    for {set z 0} {$z <= [expr $cycle + 1]} {incr z} {          ;# Only the positive Z part as the negative Z is a mirror around the zero plane
        for {set y $fromHalfSize} {$y <= $toHalfSize} {incr y} {
            for {set x $fromHalfSize} {$x <= $toHalfSize} {incr x} {
                set ::cube($cycle,$x,$y,$z) 0
            }
        }
    }
    set ::cube($cycle,toHalfSize)   [expr $toHalfSize  -1]      ;# Save that we can reuse it, but remove the extra one ;-)
    set ::cube($cycle,fromHalfSize) [expr $fromHalfSize+1]
    if {$cycle == 0} {                                          ;# For cycle zero, fill in with the input
        set toHalfSize   [expr $::dimension/2]
        set fromHalfSize [expr -1*$toHalfSize] 
        for {set y $fromHalfSize} {$y <= $toHalfSize} {incr y} {
            set values [lindex $::input [expr $y+$toHalfSize]]  ;# Offset the negative coordinates from -1*halfLength <-> 1*halfLength back to 0 <-> fullLength
            set values [split $values ""]
            for {set x $fromHalfSize} {$x <= $toHalfSize} {incr x} {
                set ::cube($cycle,$x,$y,0) [lindex $values [expr $x+$toHalfSize]]
            }
        }
    }
}


proc printCube {cycle} {                                        ;# For visualization only
    set toHalfSize   $::cube($cycle,toHalfSize)
    set fromHalfSize $::cube($cycle,fromHalfSize)
    puts "\n\nAfter $cycle cycles:"
    for {set z [expr -1*$cycle]} {$z <= $cycle} {incr z} {      ;# Do print the mirrored negative Z planes, see the abs($z) further!
        puts "\n z=$z"
        for {set y $fromHalfSize} {$y <= $toHalfSize} {incr y} {
            for {set x $fromHalfSize} {$x <= $toHalfSize} {incr x} {
                puts -nonewline " $::cube($cycle,$x,$y,[expr abs($z)])"
            }
            puts ""
        }
    }
}


proc getNrOfActiveNeighbours {cycle X Y Z} {
    set sumActive 0
    for {set z -1} {$z <= 1} {incr z} {
        set neighbourZ [expr abs($Z+$z)]                        ;# For layer 0, layer -1 should become 1 (mirror)
        if {$neighbourZ > [expr $cycle + 1]} {continue}
        for {set y -1} {$y <= 1} {incr y} {
            set neighbourY [expr $Y+$y]
            if {[expr abs($neighbourY)] > $::cube($cycle,toHalfSize)} {continue}
            for {set x -1} {$x <= 1} {incr x} {
                set neighbourX [expr $X+$x]
                if {[expr abs($neighbourX)] > $::cube($cycle,toHalfSize)} {continue}
                incr sumActive $::cube($cycle,$neighbourX,$neighbourY,$neighbourZ)
            }
        }
    }
    set sumActive [expr $sumActive - $::cube($cycle,$X,$Y,$Z)]  ;# Do not count yourself (instead of checking in the triple loop, just do a substraction here)
    return $sumActive
}


proc runCycle {cycle} {
    if {$cycle == 0} {return}
    set toHalfSize   $::cube($cycle,toHalfSize)
    set fromHalfSize $::cube($cycle,fromHalfSize)
    for {set z 0} {$z <= $cycle} {incr z} {
        for {set y $fromHalfSize} {$y <= $toHalfSize} {incr y} {
            for {set x $fromHalfSize} {$x <= $toHalfSize} {incr x} {
                set ownState $::cube([expr $cycle-1],$x,$y,$z)
                set neighboursState [getNrOfActiveNeighbours [expr $cycle-1] $x $y $z]
                if {$ownState == 1} {
                    if {($neighboursState == 2) || ($neighboursState == 3)} {
                        set ::cube($cycle,$x,$y,$z) 1           ;# Only set the active states, no need to re-set inactive states (was done in initializeCube)
                    }
                } else {
                    if {$neighboursState == 3} {
                        set ::cube($cycle,$x,$y,$z) 1
                    }
                }
            }
        }
    }
}


proc countActive {cycle} {
    set toHalfSize   $::cube($cycle,toHalfSize)
    set fromHalfSize $::cube($cycle,fromHalfSize)
    set sumActive 0
    for {set z [expr -1*$cycle]} {$z <= $cycle} {incr z} {  ;# Do count the mirrored negative Z planes, see the abs($z) further!
        for {set y $fromHalfSize} {$y <= $toHalfSize} {incr y} {
            for {set x $fromHalfSize} {$x <= $toHalfSize} {incr x} {
                incr sumActive $::cube($cycle,$x,$y,[expr abs($z)])
            }
        }
    }
    return $sumActive
}


proc runCycles {nrOfCycles} {
    for {set i 0} {$i <= $nrOfCycles} {incr i} {
        initializeCube $i
        runCycle $i
        # printCube $i
    }
    puts [countActive $nrOfCycles]
}


runCycles 6


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b




# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------




# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
