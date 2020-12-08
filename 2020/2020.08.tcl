# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set nrOfInstructions        [llength $input]
set executedInstructions    [lrepeat $nrOfInstructions 0]

set accumulatorValue        0

for {set i 0} {$i < $nrOfInstructions} {} {
    if {[lindex $executedInstructions $i]} {
        break;                                                          ;# Break if this instruction has already been executed; start of infinite loop
    }
    lset executedInstructions $i 1                                      ;# Keep track of already executed instructions
    regexp {(.+)\s(.+)} [lindex $input $i] all operation argument       ;# Analyze instruction; no checks, input is clean
    switch $operation {
        acc {
            incr accumulatorValue $argument
            incr i
        }
        jmp {
            incr i $argument                                            
        }
        nop -
        default {
            incr i                                                      ;# Default should not be needed (clean input), nop falls through to this
        }
    }
}

puts $accumulatorValue


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b




# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.08:a
# 1384


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
