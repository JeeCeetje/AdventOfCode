# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

proc runInstructions {instructionList} {
    set nrOfInstructions        [llength $instructionList]
    set executedInstructions    [lrepeat $nrOfInstructions 0]

    set accumulatorValue        0

    for {set i 0} {$i < $nrOfInstructions} {} {
        if {[lindex $executedInstructions $i]} {
            return "infinite $accumulatorValue"                                 ;# Break if this instruction has already been executed; start of infinite loop
        }
        lset executedInstructions $i 1                                          ;# Keep track of already executed instructions
        regexp {(.+)\s(.+)} [lindex $instructionList $i] all operation argument ;# Analyze instruction; no checks, input is clean
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
                incr i                                                          ;# Default should not be needed (clean input), nop falls through to this
            }
        }
    }
    return "finite $accumulatorValue"                                           ;# Instructions are finite
}

puts [lindex [runInstructions $input] 1]


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b

for {set i [expr [llength $input] -1]} {$i >= 0} {incr i -1} {                  ;# Start searching from end of instructions...
    if {[regexp {(nop|jmp)\s(.+)} [lindex $input $i] all operation argument]} {
        set newInput $input                                                     ;# ...and try replacing a nop/jmp with jmp/nop
        if {$operation == "nop"} {
            lset newInput $i "jmp $argument"
        } else {
            lset newInput $i "nop $argument"
        }
        set result [runInstructions $newInput]                                  ;# Test if this yields a finite instruction list
        if {[lindex $result 0] == "finite"} {
            puts [lindex $result 1]
            break;
        }
    }
}



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.08:a
# 1384
# 2020.08:b
# 761


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
