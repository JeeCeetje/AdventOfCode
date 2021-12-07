# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] ","]
# set input       [split [read [open $puzzleNr\_example.txt r]] ","]



# --------------------------------------------------------------------------------
# Question A
# --------------------------------------------------------------------------------
puts $puzzleNr:a

# Sort input in locations (and find the maximum location in the mean time)
set max 0
foreach i $input {
    incr loc($i)
    if {$i > $max} {set max $i}
}

# Calculate right movement
set nrOfCrabsMoving 0
set fuelCrabsMoving 0
for {set i 0} {$i <= $max} {incr i} {
    incr fuelCrabsMoving $nrOfCrabsMoving
    set  fuelUsage($i)   $fuelCrabsMoving ;# set
    if {[info exists loc($i)]} {
        incr nrOfCrabsMoving $loc($i)
    }
}

# Calculate left movement and add to the right movement
set nrOfCrabsMoving 0
set fuelCrabsMoving 0
for {set i $max} {$i >= 0} {incr i -1} {
    incr fuelCrabsMoving $nrOfCrabsMoving
    incr fuelUsage($i)   $fuelCrabsMoving ;# incr
    if {[info exists loc($i)]} {
        incr nrOfCrabsMoving $loc($i)
    }
}

# Find minimum fuel usage
set minimumFuelUsage 1000000000
for {set i 0} {$i <= $max} {incr i} {
    if {$fuelUsage($i) < $minimumFuelUsage} {
        set minimumFuelUsage $fuelUsage($i)
    }
}

puts $minimumFuelUsage



# --------------------------------------------------------------------------------
# Question B
# --------------------------------------------------------------------------------
puts $puzzleNr:b

# Calculate fuel cost for distance movement
set fuelCost(0) 0
for {set i 1} {$i <= $max} {incr i} {
    set fuelCost($i) [expr $fuelCost([expr $i-1]) + $i]
}

# Calculate new right movement 
for {set i 0} {$i <= $max} {incr i} {
    set fuelUsage($i) 0 ;# Clear old calculation
    for {set j 0} {$j < $i} {incr j} {
        if {[info exists loc($j)]} {
            incr fuelUsage($i) [expr $loc($j) * $fuelCost([expr abs($i-$j)])]
        }
    }
}

# Calculate new left movement and add to the right movement
for {set i $max} {$i >= 0} {incr i -1} {
    for {set j $max} {$j > $i} {incr j -1} {
        if {[info exists loc($j)]} {
            incr fuelUsage($i) [expr $loc($j) * $fuelCost([expr abs($i-$j)])]
        }
    }
}

# Find minimum fuel usage
set minimumFuelUsage 1000000000
for {set i 0} {$i <= $max} {incr i} {
    if {$fuelUsage($i) < $minimumFuelUsage} {
        set minimumFuelUsage $fuelUsage($i)
    }
}

puts $minimumFuelUsage



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2021.07:a
# 344605
# 2021.07:b
# 93699985



# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------


