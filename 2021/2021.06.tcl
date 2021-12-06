# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] ","]
# set input       [split [read [open $puzzleNr\_example.txt r]] ","]
set len         [llength $input]



# --------------------------------------------------------------------------------
# Question A
# --------------------------------------------------------------------------------
puts $puzzleNr:a

# Init and put input in batches
for {set i 0} {$i < 9} {incr i} { set  batch($i) 0 }
foreach i $input                { incr batch($i)   }

set nrOfDays 80
for {set d 0} {$d < $nrOfDays} {incr d} {
    set spawning $batch(0)
    for {set i 1} {$i < 9} {incr i} {
        set batch([expr $i-1]) $batch($i)
    }
    incr batch(6) $spawning
    set  batch(8) $spawning
}

set sum 0
for {set i 0} {$i < 9} {incr i} {
    incr sum $batch($i)
}
puts $sum



# --------------------------------------------------------------------------------
# Question B
# --------------------------------------------------------------------------------
puts $puzzleNr:b

# Continue the previous run for another 256-80 days
set nrOfDays [expr 256-80]
for {set d 0} {$d < $nrOfDays} {incr d} {
    set spawning $batch(0)
    for {set i 1} {$i < 9} {incr i} {
        set batch([expr $i-1]) $batch($i)
    }
    incr batch(6) $spawning
    set  batch(8) $spawning
}

set sum 0
for {set i 0} {$i < 9} {incr i} {
    incr sum $batch($i)
}
puts $sum



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2021.06:a
# 355386
# 2021.06:b
# 1613415325809



# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------


