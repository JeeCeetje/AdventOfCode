# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]
# set input       [split [read [open $puzzleNr\_example.txt r]] \n]



# --------------------------------------------------------------------------------
# Question A
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set corruptedInput {}
set incompleteInput {}

proc removeValidChunks {line} {
    set stillRemoving 1
    while {$stillRemoving > 0} {
        set stillRemoving 0
        incr stillRemoving [regsub -all {\(\)} $line "" line] ;# ()
        incr stillRemoving [regsub -all {\[\]} $line "" line] ;# []
        incr stillRemoving [regsub -all {\{\}} $line "" line] ;# {}
        incr stillRemoving [regsub -all {\<\>} $line "" line] ;# <>
    }
    return $line
}

proc findFirstCorruptedChunk {line} {
    set corrupt {}
    lappend corrupt {*}[regexp -all -inline -indices {\([\]\}\>]} $line] ;# ( not)
    lappend corrupt {*}[regexp -all -inline -indices {\[[\)\}\>]} $line] ;# [ not]
    lappend corrupt {*}[regexp -all -inline -indices {\{[\)\]\>]} $line] ;# { not}
    lappend corrupt {*}[regexp -all -inline -indices {\<[\)\]\}]} $line] ;# < not>
    set corrupt [lsort -integer -index 0 $corrupt]
    if {[llength $corrupt] == 0} {
        lappend ::incompleteInput $line
        return ""
    }
    lappend ::corruptedInput $line
    return [string range $line {*}[lindex $corrupt 0]]
}

proc getCorruptedScore {chunk} {
    set illegalChar [string range $chunk 1 1]
    # Mark the open curly bracket in a comment below to balance the closed curly bracket in switch.
    # For that reason, we also use "" for the switch code.
    switch $illegalChar {
        )     "return 3"
        ]     "return 57 ;#{"
        }     "return 1197"
        >     "return 25137"
        default "return 0"
    }    
}

set syntaxErrorScore 0
foreach i $input {
    incr syntaxErrorScore [getCorruptedScore [findFirstCorruptedChunk [removeValidChunks $i]]]
}
puts $syntaxErrorScore



# --------------------------------------------------------------------------------
# Question B
# --------------------------------------------------------------------------------
puts $puzzleNr:b

proc getCompletionScore {line} {
    set completionScore 0
    foreach c [split [string reverse $line] ""] {
        set point 0
        switch $c {
            (       {set point 1}
            [       {set point 2}
            <       {set point 4}
            default {set point 3 ;# for curly bracket}
        }
        set completionScore [expr $completionScore*5+$point]
    }
    return $completionScore
}

set completionScores {}
foreach i $incompleteInput {
    lappend completionScores [getCompletionScore $i]
}
set sortedCompletionScores [lsort -integer $completionScores]
set nrOfCompletionScores   [llength $sortedCompletionScores]

puts [lindex $sortedCompletionScores [expr $nrOfCompletionScores/2]]



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2021.10:a
# 392421
# 2021.10:b
# 2769449099



# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------


