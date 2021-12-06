# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [read [open $puzzleNr\_input.txt r]]
# set input       [read [open $puzzleNr\_example.txt r]] 



# --------------------------------------------------------------------------------
# Question A
# --------------------------------------------------------------------------------
puts $puzzleNr:a

# Get draw numbers from input
set drawNrs [split [lindex $input 0] ","]

# Get boards from input
set boards [regexp -all -inline {(\s+\d+){25}} $input]              ;# Return list of board (as input string with newlines) + last number of board
set nrOfBoards [expr [llength $boards]/2]                           ;# Ignore the last number of each board in the boards list
for {set i 0} {$i < $nrOfBoards} {incr i} {
    set board($i) [regexp -all -inline {\d+} [lindex $boards [expr $i*2]]]
}

# Init best/worst board
set bestCnt     [llength $drawNrs]
set bestBoard   -1
set worstCnt    0
set worstBoard  -1

# Find till bingo for each board
for {set i 0} {$i < $nrOfBoards} {incr i} {
    # Loop over the numbers
    foreach d $drawNrs {
        # Keep the amount of numbers till this board has bingo
        incr board($i,cnt)
        # Does this board contain the number?
        set loc [lsearch $board($i) $d]
        if {$loc > -1} {
            # Keep the sum of the found numbers
            incr board($i,sumMarked) $d
            # Increment the row and column where this number is found
            set x [expr $loc%5]
            set y [expr $loc/5]
            incr board($i,x,$x)
            incr board($i,y,$y)
            # Is it bingo? Is there a row or column with 5 found numbers?
            if {($board($i,x,$x) == 5) || ($board($i,y,$y) == 5)} {
                # Save the last number for result calculation
                set board($i,lastNr) $d
                # Is this the best board?
                if {$board($i,cnt) < $bestCnt} {
                    set bestCnt $board($i,cnt)
                    set bestBoard $i
                }
                # Is this the worst board?
                if {$board($i,cnt) > $worstCnt} {
                    set worstCnt $board($i,cnt)
                    set worstBoard $i
                }
                # Break the drawNrs loop
                break
            }
        }
    }
}

# Calculate result best board
set resultA 0
foreach n $board($bestBoard) {
    incr resultA $n
}
set resultA [expr ($resultA - $board($bestBoard,sumMarked)) * $board($bestBoard,lastNr)]
puts $resultA



# --------------------------------------------------------------------------------
# Question B
# --------------------------------------------------------------------------------
puts $puzzleNr:b

# Calculate result worst board
set resultB 0
foreach n $board($worstBoard) {
    incr resultB $n
}
set resultB [expr ($resultB - $board($worstBoard,sumMarked)) * $board($worstBoard,lastNr)]
puts $resultB



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2021.04:a
# 22680
# 2021.04:b
# 16168



# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------


