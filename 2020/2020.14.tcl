# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set andMask 0
set orMask  0

set mem     ""

foreach i $input {
    
    # Handle masks
    if {[regexp {mask = (.*)} $i all mask]} {
        regsub -all {X} $mask "1" andMask                                                       ;# Create an AND mask to force the '0's
        set andMask 0b$andMask
        regsub -all {X} $mask "0" orMask                                                        ;# Create an OR mask to force the '1's
        set orMask 0b$orMask
        
    # Handle memory writes (mask the value)
    } elseif {[regexp {mem\[(\d+)\] = (\d+)} $i all address value]} {
        set virtualAddress [lsearch -index 0 -integer $mem $address]                            ;# We won't keep the 36bit memoryspace; as there are 32 bit values, that would be 256GiB ;-)
                                                                                                ;# So we keep the writes in a list, the index location of that write is the 'virtual' address
        set maskedValue       [expr $value & $andMask | $orMask]
        if {$virtualAddress >= 0} {                                                             ;# If the virtual address >=0...
            set mem [lreplace $mem $virtualAddress $virtualAddress "$address $maskedValue"]     ;# ...than we've already written to that address, update it...
        } else {
            lappend mem "$address $maskedValue"                                                 ;# ... else, it's a new write, add it to the list
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

set andMask             0
set orMask              0
set floatingBitIndexes  ""
set floatingNrOfBits    0
set floatingNrOfAddr    0

set mem                 ""

foreach i $input {
    
    # Handle masks
    if {[regexp {mask = (.*)} $i all mask]} {
        regsub -all {0} $mask "1" andMask
        regsub -all {X} $andMask "0" andMask                                                    ;# Create an AND mask to force '0's on 'X' bit locations and keep the rest as is
        set andMask 0b$andMask
        regsub -all {X} $mask "0" orMask                                                        ;# Create an OR mask to force the '1's
        set orMask 0b$orMask
        set floatingBitIndexes  [lsearch -all [split [string reverse $mask] ""] "X"]            ;# At which bit locations are there 'X's? Reverse the bit string to have correct indexes (0 for most rightmost bit)
        set floatingNrOfBits    [llength $floatingBitIndexes]                                   ;# How many 'X's are there?
        set floatingNrOfAddr    [expr 2**$floatingNrOfBits]                                     ;# Thus how many floating addresses are there?
        
    # Handle memory writes (mask the address)
    } elseif {[regexp {mem\[(\d+)\] = (\d+)} $i all address value]} {
        
        set maskedAddress [expr $address & $andMask | $orMask]                                  ;# If we have an address, mask it with the AND and OR masks
        for {set f 0} {$f < $floatingNrOfAddr} {incr f} {                                       ;# Loop over all possible addresses...
            set currAddress $maskedAddress
            for {set b 0} {$b < $floatingNrOfBits} {incr b} {                                   ;# ... and for each of them, place the bits on the correct bit positions
                set bit [expr ($f>>$b)&0x1]                                                     ;# Because we forced zeroes on the X locations, we don't need to worry about AND'ing and OR'ing in case of a zero...
                set currAddress [expr $currAddress + ($bit<<[lindex $floatingBitIndexes $b])]   ;# ... just add the shifted '1' (or shifted '0' for which the whole number is zero)
            }
            
            set virtualAddress [lsearch -index 0 -integer $mem $currAddress]                    ;# Same as in question 1
            if {$virtualAddress >=0} {
                set mem [lreplace $mem $virtualAddress $virtualAddress "$currAddress $value"]
            } else {
                lappend mem "$currAddress $value"
            }
        }
    }
}

set sumMem 0
foreach m $mem {
    incr sumMem [lindex $m 1]
}
puts $sumMem


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.14:a
# 12512013221615
# 2020.14:b
# 3905642473893


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------

# Is there a better way for question 2? This way almost takes about 75 seconds to complete.
