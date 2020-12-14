# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]
# set input       [split [read [open $puzzleNr\_example.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set andMask 0
set orMask  0
set mem     ""
foreach i $input {
    if {[regexp {mask = (.*)} $i all mask]} {
        regsub -all {X} $mask "1" andMask
        set andMask 0b$andMask
        regsub -all {X} $mask "0" orMask
        set orMask 0b$orMask
    } elseif {[regexp {mem\[(\d+)\] = (\d+)} $i all address value]} {
        set virtualAddress [lsearch -index 0 -integer $mem $address]
        set maskedValue       [expr $value & $andMask | $orMask]
        if {$virtualAddress >=0} {
            set mem [lreplace $mem $virtualAddress $virtualAddress "$address $maskedValue"]
        } else {
            lappend mem "$address $maskedValue"
        }
    }
}

set sumMem 0
foreach m $mem {
    incr sumMem [lindex $m 1]
}
puts $sumMem


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.14:a
# 12512013221615


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
