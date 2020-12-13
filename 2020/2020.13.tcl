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

set busses ""                                                       ;# Create a list of the relevant busses
for {set i 0} {$i < [llength $busIDs]} {incr i} {
    if {[lindex $busIDs $i] == "x"} {
        continue
    }
    set modulus     [lindex $busIDs $i]
    set remainder   [expr ($modulus-$i)%$modulus]                   ;# The %modulus is needed when i = 0, otherwise remainer = modulus which is incorrrect
    lappend busses "$remainder $modulus"                            ;# (remainder, modulus)
}

set sortedBusses [lsort -integer -decreasing -index 1 $busses]      ;# Sort that list, decreasing, on the busID or modulus

# Chinese remainder theorem                                         ;# "Search by sieving"
set searchValue     [lindex [lindex $sortedBusses 0] 0]             ;# Start with the remainder of the largest modulus
set incrementValue  1                                               ;# Will be set in the loop, it's the multiplication of the moduli
for {set i 0} {$i < [expr [llength $sortedBusses]-1]} {incr i} {
    set incrementValue  [expr $incrementValue * [lindex [lindex $sortedBusses $i] 1]]
    set nextModulus     [lindex [lindex $sortedBusses [expr $i+1]] 1]
    set nextRemainder   [lindex [lindex $sortedBusses [expr $i+1]] 0]
    while {[expr $searchValue % $nextModulus] != $nextRemainder} {  ;# As long as the current value doesn't result in the next remainder with the next modulus, ...
        incr searchValue $incrementValue                            ;# ...increment with the increment value (which is the current multiplication of the moduli).
    }
}

puts $searchValue


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.13:a
# 2095
# 2020.13:b
# 598411311431841


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------

# Question 2: Before the tip was given that the bus IDs were prime numbers, a more brute force way of doing it was used.
# That method worked, fast even for the examples but takes AGES to complete for the real deal...
# Literally, so no solution would be found. However I was on the right track, using moduli (like in the first question)
# and sorting them on decreasing value and working towards the solution. See previous revision of the code.
# This puzzle was not only about programming, it was also about a mathematical solution; the Chinese remainder theorem.
# I wouldn't have found the solution on my own, but after reading the wiki (https://en.wikipedia.org/wiki/Chinese_remainder_theorem),
# I settled with the "search by sieving" method. While the method wasn't described as very efficient and typically (quote) "not used
# on computers", implementing the method seemed well withing the typical scope of the AoC puzzles. A solution was found within the second.
