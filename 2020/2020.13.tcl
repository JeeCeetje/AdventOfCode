# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set timeStamp [lindex $input 0]
set busIDs    [split [lindex $input 1] ","]

set minimumWaitTime 999999
set chosenBusID     0
foreach id $busIDs {
    if {$id == "x"} {
        continue
    }
    set waitTime [expr $id - ($timeStamp % $id)]
    if {$waitTime < $minimumWaitTime} {
        set minimumWaitTime $waitTime
        set chosenBusID     $id
    }
}

puts [expr $minimumWaitTime * $chosenBusID]


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b

set busses ""                                                   ;# Create a list of the relevant busses and their offset
for {set i 0} {$i < [llength $busIDs]} {incr i} {
    if {[lindex $busIDs $i] == "x"} {
        continue
    }
    lappend busses "$i [lindex $busIDs $i]"                     ;# (offset, busID)
}

set sortedBusses [lsort -integer -decreasing -index 1 $busses]  ;# Sort that list on the largest busID


set highestBusId        [lindex [lindex $sortedBusses 0] 1]     ;# Grab and save the highest busId from that list
set highestBusIdOffset  [lindex [lindex $sortedBusses 0] 0]
set sortedBusses        [lreplace $sortedBusses 0 0]            ;# Remove it from the list itself
set nrOfBusses          [llength $sortedBusses]


set startingPoint 100000000000000                               ;# Use the tip from the riddle
set i [expr $startingPoint/$highestBusId]

set runTime [time {
set found $nrOfBusses
while {$found} {                                                ;# The result is found when the found counter becomes 0
    incr i
    set result [expr $i*$highestBusId - $highestBusIdOffset]    ;# Speed up by multiplying with the largest number
    set found $nrOfBusses
    foreach bus $sortedBusses {                                 ;# Test each bus but stop as soon as one fails
        if {!([expr ($result+[lindex $bus 0])%[lindex $bus 1]] == 0)} {
            break
        }
        incr found -1
    }
}
}]

puts [expr $i*$highestBusId - $highestBusIdOffset]
puts $runTime


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.13:a
# 2095


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------

# WARNING: question 2 works for the examples but takes AGES to complete for the real deal...
